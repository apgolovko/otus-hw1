from functools import reduce
from pathlib import Path

import click
import pydoop.hdfs as hdfs
import pyspark.sql.functions as spark_f
from pyspark.sql import SparkSession


def get_list_of_file_path(path):
    return [str(Path(path) / file_path.split(path)[1]) for file_path in hdfs.ls(path)]


@click.command()
@click.option('--input_filepath', 'input_filepath')
@click.option('--output_filepath', 'output_filepath')
def data_prepare(input_filepath, output_filepath):
    # input_filepath = Path(input_filepath)
    # output_filepath = Path(output_filepath)

    spark = SparkSession.builder.appName("OTUS-HW3").getOrCreate()

    print("READ")
    sdf = spark.read.parquet(*get_list_of_file_path(input_filepath), mergeSchema=True)
    print("READ OK")
    
    print("DROP")
    sdf = sdf.dropDuplicates(['tranaction_id'])
    sdf = sdf.where(spark_f.col('customer_id') >= 0)
    sdf = sdf.where(spark_f.col('tx_amount') <= 200)
    print("DROP OK")

    print("WRITE")
    sdf.repartition(40).write.parquet(f'{output_filepath}/dataset.parquet')
    print("WRITE OK")

if __name__ == '__main__':
    data_prepare()