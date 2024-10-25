from functools import reduce
from pathlib import Path

import click
import pydoop.hdfs as hdfs
from pyspark.sql import SparkSession


def read_header(file_path):
    with hdfs.open(file_path, 'r') as rf:
        header = rf.readline()
    
    return header.decode("utf-8").replace('\n', '').replace('#', '').replace(' ', '').split('|')

def replace_header(sdf, header):
    old_header = sdf.schema.names

    return reduce(lambda sdf, idx: sdf.withColumnRenamed(sdf.schema.names[idx], header[idx]), range(len(old_header)), sdf)

def get_list_of_file_path(path):
    return [str(Path(path) / file_path.split(path)[1]) for file_path in hdfs.ls(path)]


@click.command()
@click.option('--input_filepath', 'input_filepath')
@click.option('--output_filepath', 'output_filepath')
def data_prepare(input_filepath, output_filepath):
    input_filepath = Path(input_filepath)
    output_filepath = Path(output_filepath)

    spark = SparkSession.builder.appName("OTUS-HW3").getOrCreate()

    for file_path in get_list_of_file_path(input_filepath):
        print(file_path)
        header = read_header(file_path)
        new_file_path = output_filepath / f'{Path(file_path).stem}.parquet'

        sdf = spark.read.csv(file_path, sep=',', header=False, comment='#')
        sdf = replace_header(sdf, header)

        sdf.write.mode("overwrite").parquet(new_file_path)
        hdfs.rm(file_path)


if __name__ == '__main__':
    data_prepare()
