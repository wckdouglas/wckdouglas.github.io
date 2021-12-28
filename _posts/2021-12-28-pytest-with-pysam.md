---
layout: post
title: "Pytest with BAM/SAM"
date: 2020-07-10T17:35:57-04:00
---

This post shows a way to test for a BAM I/O function without actually reading/writing to disk using [mock objects](https://docs.python.org/3/library/unittest.mock.html). 

Let’s say we have a simple function (filtering out alignment with query sequence shorter than 10 bp):

```python
from pathlib import Path
import pysam

def filter_short_alignments(in_bam_file: Path, out_bam_file: Path):
    """
    reading the input bam file and write alignments with >10 bases to output bam file
    
    :param str in_bam_file: file path to input bam file
    :param str out_bam_file: file path to output bam file
    """
    with pysam.AlignmentFile(in_bam_file) as inbam:
        with pysam.AlignmentFile(out_bam_file, 'wb', template=inbam) as outbam:
            for aln in inbam:
                if len(aln.query_sequence) > 10:
                    outbam.write(aln)
```

In theory this function only takes input and output bam file names for it to run. However, for unit testings, sometimes we don’t want to include a test file for testing this function. This is when mock objects become handy.

To mock the returning values from pysam.AlignmentFile, we’d need a fake pysam object so that the for loop iteration of alignments will still work:

```python
class PysamFakeBam:
    def __init__(self, header, reads):
        """
        a mock object that mimics the pysam.AlignmentFile object
        :param pysam.AlignmentHeader header: header of the mock sam file
        :param List[pysam.AlignedSegment] reads: reads of the mock sam file
        """
        self.header = header
        self.reads = reads

    def __iter__(self):
        return iter(self.reads)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        return self

    def close(self):
        return self  
```

And then we will need a functions to create fake bam header and alignments:

```python
def mock_bam_header(contig_list):
    """
    making a mock pysam.AlignmentHeader object
    Example::
        contigs = [("chr1", 10), ("chr2", 20)]
        mock_header = mock_bam_header(contigs)
    :param List[Tuple[str, int]] contig_list: a list of tuples of (contig name, contig length)
    :return: a pysam.AlignmentHeader object
    :rtype: pysam.AlignmentHeader
    """
    header_dict = OrderedDict(
        [
            ("SQ", [dict(SN=contig[0], LN=contig[1]) for contig in contig_list]),
            (
                "PG",
                [
                    {"ID": "bwa", "PN": "bwa",},
                    {"ID": "samtools", "PN": "samtools", "PP": "bwa", "VN": "1.13", "CL": "samtools view -b",},
                ],
            ),
        ]
    )
    return pysam.AlignmentHeader.from_dict(header_dict)


def mock_alignment(
    header,
    reference_name,
    query_name,
    query_sequence,
    reference_start,
    cigar,
    flag,
    mapping_quality,
    next_reference_name=None,
    next_reference_start=None,
):
    """
    making a mock pysam.AlignedSegment object
    :param pysam.AlignmentHeader header_dict: a pysam alignment header object (can be created by mock_bam_header)
    :param str reference_name: reference name
    :param str query_name: query name
    :param str query_sequence: query sequence
    :param int reference_start: reference start
    :param list cigar: cigar
    :param int flag: flag
    :param int mapping_quality: mapping quality
    :param str next_reference_name: reference name for the paired end alignment mapped
    :param int next_reference_start: reference start of the paired end alignment
    """
    alignment = pysam.AlignedSegment(header)
    alignment.reference_name = reference_name
    alignment.query_name = query_name
    alignment.query_sequence = query_sequence
    alignment.reference_start = reference_start
    alignment.cigar = cigar
    alignment.flag = flag
    alignment.mapping_quality = mapping_quality
    if next_reference_name is not None and next_reference_start is not None and next_reference_start > 0:
        alignment.next_reference_name = next_reference_name
        alignment.next_reference_start = next_reference_start
    return alignment
```

Now that we have these helper functions, we can start writing our test:

```python
def test_filter_short_alignments():
    header = mock_bam_header([('chr1', 100)]) # mock a 100 bp chr1 contig
    in_alignment = mock_alignment(
        header=header,
        reference_name='chr1',
        query_name='aln1',
        query_sequence='NNNNNNNNNNN', #a 11 bp alignment, shouldn't be filtered out
        reference_start=10, 
        cigar=[(0, 11)],
        flag=0,
        mapping_quality=30,
    )
    with patch("pysam.AlignmentFile") as pysam_bam:
        mock_in_bam = PysamFakeBam(header, [in_alignment]) #the mock in bam iterarotor will return our mock alignment
        mock_out_bam = MagicMock()
        pysam_bam.return_value.__enter__.side_effect = [mock_in_bam, mock_out_bam] #first call of the pysam.AlignmentFile will return mock_in_bam, second call will be mock_out_bam
        filter_short_alignments("/path/to/inbam", "/path/to/outbam") #these files are not real, because we are mocking the return of the call anyways
        
        mock_out_bam.write.assert_called_once_with(in_alignment) #because the filter function wouldn't touch alignments with >10 bases
```