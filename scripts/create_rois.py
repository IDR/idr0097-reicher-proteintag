#! /usr/bin/env python

import pandas
import omero
from omero.cli import cli_login
from omero.gateway import BlitzGateway
from omero.model import PointI, RoiI, ImageI
from omero.rtypes import rdouble, rint


def create_points(conn, f, imageid):

    img = conn.getObject('Image', imageid)
    name = img.getName()
    df = pandas.read_csv(f, delimiter='\t')
    x = [float(x) for x in df[df['Source Name'] == name]['Location_X']]
    y = [float(x) for x in df[df['Source Name'] == name]['Location_Y']]
    text = list(df[df['Source Name'] == name]['Tagged Protein'])
    
    for i, j, k in zip(x, y, text):
        p = omero.model.PointI()
        p.x = rdouble(i)
        p.y = rdouble(j)
        roi = omero.model.RoiI()    
        roi.addShape(p)
        roi.setImage(omero.model.ImageI(imageid, False))
        roi.setTextValue(rstring(k))
        conn.getUpdateService().saveAndReturnObject(roi)


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('file', type=str)
    parser.add_argument('imageid', type=int)
    parser.add_argument(
        '--verbose', '-v', action='count', default=0,
        help='Increase the command verbosity')
    parser.add_argument(
        '--quiet', '-q', action='count', default=0,
        help='Decrease the command verbosity')
    args = parser.parse_args(argv)

    with omero.cli.cli_login() as c:
        conn = omero.gateway.BlitzGateway(client_obj=c.get_client())
        create_points(conn, args.file, args.imageid)
