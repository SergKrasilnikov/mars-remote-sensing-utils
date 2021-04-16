import re
import struct
import pathlib
import numpy as np
import pandas as pd


class SharadGeom:

    def __init__(self):
        pass

    @classmethod
    def load(cls, file):
        """ Load a SHARAD geometry from a file.

        Notes:
            Unlike MARSIS data, where each row of a .dat binary table represents one trace, in SHARAD .img files each
            row corresponds to the actual row of the radargram image.

        """

        out = pd.read_csv(file, names=sharad_headers)

        return out


class SharadRgram:

    def __init__(self):
        pass

    @classmethod
    def load(cls, file):
        """ Load a SHARAD .img file.

        Notes:
            Unlike MARSIS data, where each row of a .dat binary table represents one trace, in SHARAD .img files each
            row corresponds to the actual row of the radargram image.

        """

        # calculate the number of records in a file.
        # each trace has a fixed length of 3600 and each sample is 4 byte
        file_size = pathlib.Path(file).stat().st_size
        n_records = int(file_size / 3600 / 4)

        # generate a struct format string for each row
        fstr = '<' + 'f' * n_records

        # create the data matrix. for consistency with MARSIS data, it will be transposed
        data_matrix = np.empty((3600, n_records), dtype=np.float32)

        with open(file, 'br') as f:
            for i in range(3600):
                data_matrix[i] = struct.unpack(fstr, f.read(n_records * 4))

        return data_matrix.T


class SharadImage:
    """ """

    def __init__(self):
        """ """

        self.G = None
        self.DM = None

    @classmethod
    def load(cls, file):
        """ Load a SHARAD image and its geometry from a file.

        Args:
            file (str): Path to the .img or .geom file.

        """

        file = str(file)

        if 'geom.tab' in file:
            geom_file = file
            rgram_file = file.replace('geom.tab', 'rgram.img')
        elif 'rgram.img' in file:
            geom_file = file.replace('rgram.img', 'geom.tab')
            rgram_file = file
        else:
            raise ValueError('Not a SHARAD file.')

        orbit_regex = re.compile(r's_(\d{6})(\d{2})_(?:geom.tab|rgram.img)')
        orbit, observation = map(int, orbit_regex.findall(file)[0])

        try:
            geom = SharadGeom.load(geom_file)
        except FileNotFoundError:
            geom = None

        try:
            rgram = SharadRgram.load(rgram_file)
        except FileNotFoundError:
            rgram = None

        out = cls()
        out.G = geom
        out.DM = rgram
        out.file = file
        out.orbit = orbit
        out.observation = observation

        return out


sharad_headers = [
    'RADARGRAM COLUMN',
    'TIME',
    'LATITUDE',
    'LONGITUDE',
    'MARS RADIUS',
    'SPACECRAFT RADIUS',
    'RADIAL VELOCITY',
    'TANGENTIAL VELOCITY',
    'SZA',
    'PHASE/1.0E16'
]
