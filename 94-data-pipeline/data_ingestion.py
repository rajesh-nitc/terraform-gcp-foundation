import argparse
from typing import Dict
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input',
                        dest='input',
                        required=True,
                        help='Input file to read from GCS.'
                        )
    parser.add_argument('--output',
                        dest='output',
                        required=True,
                        help='Output BQ table to write results to.'
                        )
    known_args, pipeline_args = parser.parse_known_args()
    return known_args, pipeline_args


def transform(data: Dict[str, str]):
    data["year"] = "-".join((data["year"], "01", "01"))
    data["number"] = int(data["number"])
    return data


def main():
    known_args, pipeline_args = parse_args()
    p = beam.Pipeline(options=PipelineOptions(pipeline_args))

    (p

     | 'Read Single Line' >> beam.io.ReadFromText(known_args.input, skip_header_lines=0)
     | 'Split the line' >> beam.Map(lambda x: x.split(','))
     | 'Create Dict' >> beam.Map(lambda x: {"state": x[0], "gender": x[1], "year": x[2], "name": x[3], "number": x[4], "created_date": x[5]})
     | 'Transform fields' >> beam.Map(transform)
     | 'Write to Bigquery' >> beam.io.WriteToBigQuery(
         known_args.output,
         schema='state:STRING,gender:STRING,year:DATE,name:STRING,number:INTEGER,created_date:STRING',
         create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
         write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND)
     )

    p.run().wait_until_finish()


if __name__ == "__main__":
    main()
