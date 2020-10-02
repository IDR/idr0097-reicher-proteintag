#! /usr/bin/env python

import argparse
import pandas
import omero
from omero.cli import cli_login
from omero.gateway import BlitzGateway
from omero.model import PointI, RoiI, ImageI
from omero.rtypes import rdouble, rint, rstring

import sys

PROCESSED_FILE_PATH =  (
    "/uod/idr/filesets/idr0097-reicher-proteintag/20200929-ftp/"
    "experimentB-processed.txt")


def create_points(conn, df, image):

    name = image.getName()
    iid = image.getId()
    x = [float(x) for x in df[df['Source Name'] == name]['Location_X']]
    y = [float(x) for x in df[df['Source Name'] == name]['Location_Y']]
    text = list(df[df['Source Name'] == name]['Tagged Protein'])
    
    for i, j, k in zip(x, y, text):
        p = omero.model.PointI()
        p.x = rdouble(i)
        p.y = rdouble(j)
        p.setTextValue(rstring(k))
        roi = omero.model.RoiI()    
        roi.addShape(p)
        roi.setImage(omero.model.ImageI(iid, False))
        conn.getUpdateService().saveAndReturnObject(roi)


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
    args = parser.parse_args(argv)

    df = pandas.read_csv(PROCESSED_FILE_PATH, delimiter='\t')
    with omero.cli.cli_login() as c:
        conn = omero.gateway.BlitzGateway(client_obj=c.get_client())
        images = get_timelapse_images(conn)
        for image in images:
            create_points(conn, df, image)

if __name__ == "__main__":
    main(sys.argv[1:])
