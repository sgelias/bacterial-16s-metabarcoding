import argparse
import csv
import glob
import os
import re
import string
from typing import Dict, List

import pandas as pd


class OtuTableBuilder(object):
    """
    Build a OTU table from tabular results of Blast.
    """

    def __init__(self, blast_dir: str):
        """
        Initialize the OTU table compiler.

        :param str blast_dir: The directory containing tabular results of BLAST.
        :raises InexistentBlastFilesError: If specified directory has no csv 
        files generated from BLAST.
        :raises InvalidCsvFileError: If some of the provided csv files has no 
        valid content.
        """

        try:
            self.__blast_results: List[str] = []
            os.chdir(blast_dir)
            self.__blast_results = [
                os.path.abspath(file)
                for file in glob.glob("*.csv")
            ]

        except Exception as e:
            print("An error occurred: {}".format(e))

        if len(self.__blast_results) == 0:
            raise self.InexistentBlastFilesError(
                "The specified directory has no csv files. Please verify.")

        for file in self.__blast_results:
            if not self.__validate_csv(file):
                raise self.InvalidCsvFileError(
                    "Invalid csv file. Please verify.")

    def build_otu_table(
        self, output_dir: str, reference_database: str = None, 
        suffix: str = None
    ) -> None:
        """
        Effectively build the OTU by sample table based on CSV files provided 
        at the class construction.

        :param str output_dir: The directory to save the resulting table.
        :param str reference_database: The FASTA format reference database used 
        to build the reference blastdb (using the makeblastdb method).
        :param str suffix: A string to remove from the file names.
        """

        out_df = pd.DataFrame()

        # Populate the main dataframe.
        for file in self.__blast_results:
            count = self.__populate_taxa_occurrences(file)
            out_df = pd.concat(
                [
                    out_df, 
                    pd.Series({ k: v for k, v in count.items() }) \
                        .rename(file.split('/')[-1].split('.')[0])
                ], 
                axis=1)

        # Fill numpy NAs with zeros (o) and rename columns of dataframe to match
        # with provided FASTA files names.
        sample_names = [
            file.split('/')[-1].split('.')[0]
            for file in self.__blast_results
        ]

        out_df = out_df \
            .fillna(0) \
            .rename(columns = { 
                index: item
                for index, item in enumerate(sample_names) 
            })

        # If a reference_database argument  is provided, the full taxon 
        # description are added to the dataframe row names (as the dataframe 
        # indexes).
        if reference_database:
            out_df.rename(
                index = self.__populate_otu_names(
                    out_df.index, reference_database), 
                inplace=True)

        # If a suffix argument is provided, it is removed from all column names.
        if suffix:
            out_df.rename(
                columns = {
                    head: re.sub("{}$".format(suffix), "", head)
                    for head in out_df.columns
                }, 
                inplace=True)

        # Include a correct file extension if it do not exists at the original 
        # name provided by the user.
        if not output_dir.endswith(".tsv"):
            output_dir = "{}.tsv".format(output_dir)

        # Finally, save the dataframe.
        out_df.to_csv(output_dir, sep='\t')

    def __populate_otu_names(
        self, otu_list: List[str], reference_db: str
    ) -> Dict[str, str]:
        """
        Populate OTU names from the reference database.

        :param List[str] otu_list: A list of indexes contained at the final 
        compiled dataframe.
        :param str reference_db: The file path of the reference database used 
        to build the reference blastdb (using the makeblastdb method).
        :return: All indexes specified at the otu_list argument and respectives 
        full OTU names from reference_db.
        :rtype: Dict[str, str].
        :raises InvalidFastaFileError: If provided path at the reference_db 
        argument have no a valid FASTA extension (.fasta, .fas, or .fa).
        """

        if not reference_db.endswith((".fasta", ".fas", ".fa")):
            raise self.InvalidFastaFileError(
                "Provided file is not a valid FASTA document. Please verify.")

        otu_dict: Dict[str, str] = {}
        otu_join = "|".join(otu_list)

        with open(reference_db, "r") as fasta:
            for line in fasta:
                search = re.findall(
                    r"^>({otus})\s(.+)$".format(otus = otu_join), line)

                if search:
                    otu_dict[search[0][0]] = " ".join(search[0])

        return otu_dict

    @staticmethod
    def __validate_csv(file: str) -> bool:
        """
        Check the validity of the provided csv file.

        :param str file: The csv absolute file path.
        :return: Literal True or False.
        :rtype: bool.
        :raises csv.Error: If some validation test do not pass.
        """

        try:
            with open(file, newline='') as csvfile:
                start = csvfile.read(4096)

                if not all([
                    c in string.printable or c.isprintable() 
                    for c in start
                ]):
                    return False

                csv.Sniffer().sniff(start)
                return True

        except csv.Error:
            print("File appears not to be in CSV format")
            return False

    @staticmethod
    def __populate_taxa_occurrences(file: str) -> Dict[str, int]:
        """
        Count the occurrence of all OTUs along the tabular Blast results file.

        :param str file: The csv absolute file path.
        :return: A count per OTU dict.
        :rtype: Dict[str, str].
        """

        taxa: Dict[str, int] = {}
        head: str = ""

        with open(file, "r") as blast_dir:
            for line in blast_dir:
                line = line.split(',')
                if len(line) > 0 and line[0] != head:
                    head = line[0]
                    if line[1] in taxa:
                        taxa[line[1]] += 1
                    else:
                        taxa[line[1]] = 1

        return taxa

    class InexistentBlastFilesError(Exception):
        """
        If specified directory has no csv files generated from BLAST.
        """
        pass

    class InvalidCsvFileError(Exception):
        """
        If some of the provided csv files has no valid content.
        """
        pass

    class InvalidFastaFileError(Exception):
        """
        If provided path at the reference_db argument have no a valid FASTA 
        extension (.fasta, .fas, or .fa).
        """
        pass

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description="Build a OTU by sampling table from Blastn results.\n"
    )

    required = parser.add_argument_group('required arguments')
    optional = parser.add_argument_group('optional arguments')

    required.add_argument(
        '-b', '--blastdir', required=True,
        help="The BLASTn file path.\n"
        "Ex.: --blastdir '/path/to/blastresults/'",
    )

    required.add_argument(
        '-o', '--outputdir', required=True,
        help="The output file path.\n"
        "Ex.: --outputdir '/path/to/output.tsv'",
    )

    optional.add_argument(
        '--reference_database', required=False, default=None,
        help="The FASTA reference database used to annotate OTUs.\n"
        "Ex.: --reference_database '/path/to/reference.fasta'",
    )

    optional.add_argument(
        '--cut_suffix', required=False, default=None,
        help="A suffix to remove from file name.\n"
        "Ex.: --cut_suffix '_FILTERED'",
    )

    args = parser.parse_args()

    builder = OtuTableBuilder(args.blastdir)
    builder.build_otu_table(
        args.outputdir, args.reference_database, args.cut_suffix)
