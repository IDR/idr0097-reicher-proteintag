#! /usr/bin/env python

import argparse
import pandas
from omero.cli import cli_login
from omero.gateway import BlitzGateway
from omero.model import PointI, RoiI, ImageI
from omero.rtypes import rdouble, rstring

import sys

PROCESSED_FILE_PATH = (
    "/uod/idr/filesets/idr0097-reicher-proteintag/20200929-ftp/"
    "experimentB-processed.txt")


def create_points(conn, df, image):

    columns = [
        "Sequence",
        "Tagged Protein",
        "Sequence is unique",
        "Location_X",
        "Location_Y"
    ]
    df2 = pandas.DataFrame(columns=(['roi'] + columns))
    index = df['Source Name'] == image.getName()
    for s, tp, u, x, y in zip(map(lambda x: df[index][x], columns)):
        p = PointI()
        p.x = rdouble(float(x))
        p.y = rdouble(float(y))
        p.setTextValue(rstring(tp))
        roi = RoiI()
        roi.addShape(p)
        roi.setName(rstring(tp))
        roi.setImage(ImageI(image.getId(), False))
        roi = conn.getUpdateService().saveAndReturnObject(roi)
        df2.loc[len(df2)] = (roi.getId().getValue(), s, tp, u, x, y)
    return df2


def get_timelapse_images(conn):
    project = conn.getObject(
        'Project', attributes={
            'name': 'idr0097-reicher-proteintag/experimentB'})
    datasets = project.listChildren()
    for dataset in datasets:
        if dataset.getName() == 'timelapse':
            return dataset.listChildren()


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--verbose', '-v', action='count', default=0,
        help='Increase the command verbosity')
    parser.add_argument(
        '--quiet', '-q', action='count', default=0,
        help='Decrease the command verbosity')
    parser.parse_args(argv)

    df = pandas.read_csv(PROCESSED_FILE_PATH, delimiter='\t')
    with cli_login() as c:
        conn = BlitzGateway(client_obj=c.get_client())
        images = get_timelapse_images(conn)
        for image in images:
            df2 = create_points(conn, df, image)
            iid = image.getId().getValue()
            df2.to_csv(f"{iid}.csv")


if __name__ == "__main__":
    main(sys.argv[1:])
