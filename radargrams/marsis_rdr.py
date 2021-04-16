import re
import struct
import numpy as np
import pandas as pd


class MarsisRDR:
    """ This object represents a MARSIS Reduced Data Record and contains methods to read and work with them. """

    def __init__(self):
        """ """

        # a table to store the headers
        self.G = None

        # the matrices to hold the data for each frequency
        self.DM1 = None
        self.DM2 = None

        self.qi = None
        self.file = None

    @classmethod
    def load(cls, file):
        """ Load a RDR from a file.

        Args:
            file (str): Path to the RDR file (.dat).

        """

        file = str(file)

        # first, load the label file. it contains the quality indices
        with open(file[:-4] + '.lbl', 'r') as f:
            label = f.read()

        qi_regex = re.compile(r'DATA_QUALITY_ID\s+=\s(\d)(\d)')
        n_records_regex = re.compile(r'FILE_RECORDS\s+=\s(\d+)')

        qi1, qi2 = map(int, qi_regex.findall(label)[0])
        n_records = int(n_records_regex.findall(label)[0])

        # create the table for headers and matrices for traces
        geometry = pd.DataFrame(index=range(n_records), columns=marsis_headers)
        data_matrix_1 = np.empty((n_records, 512, 6), dtype=np.float32)
        data_matrix_2 = np.empty((n_records, 512, 6), dtype=np.float32)

        # a struct format string for unpacking traces
        marsis_trace_fstr = '<' + 'f' * 512

        with open(file, 'br') as f:
            # iterate over each record, unpacking the headers into a geometry table
            # and modulus and phase values for each frequency into a separate matrix
            for i in range(n_records):
                # can't unpack the geometry as a single array because
                # some columns contain multiple values (i.e velocity vectors and central frequency)
                # these values have to be micro-managed, as a result geometry is unpacked in a series of steps
                values = struct.unpack('<fffIHffffHH', f.read(38))
                geometry.iloc[i, 0] = values[0:2]
                geometry.iloc[i, 1:8] = values[2:9]
                geometry.iloc[i, 8] = values[9:11]

                # unpack the traces
                for matrix in (data_matrix_1, data_matrix_2):
                    matrix[i, :, 0] = struct.unpack(marsis_trace_fstr, f.read(2048))
                    matrix[i, :, 1] = struct.unpack(marsis_trace_fstr, f.read(2048))
                    matrix[i, :, 2] = struct.unpack(marsis_trace_fstr, f.read(2048))
                    matrix[i, :, 3] = struct.unpack(marsis_trace_fstr, f.read(2048))
                    matrix[i, :, 4] = struct.unpack(marsis_trace_fstr, f.read(2048))
                    matrix[i, :, 5] = struct.unpack(marsis_trace_fstr, f.read(2048))

                geometry.iloc[i, 9] = struct.unpack('<d', f.read(8))[0]
                geometry.iloc[i, 10] = f.read(23).decode()  # this is the GEOMETRY_EPOCH header - a string

                values = struct.unpack('<ddI', f.read(20))
                geometry.iloc[i, 11:14] = values

                geometry.iloc[i, 14] = f.read(6).decode()  # this is the TARGET_NAME header - also a string

                values = struct.unpack('<' + 'd' * 19, f.read(152))
                geometry.iloc[i, 15] = values[0:3]
                geometry.iloc[i, 16:19] = values[3:6]
                #                 print(values[3:6])
                geometry.iloc[i, 19] = values[6:9]
                geometry.iloc[i, 20:24] = values[9:13]
                geometry.iloc[i, 24] = values[13:16]
                geometry.iloc[i, 25] = values[16:19]

        # construct an object from the read data and return it
        out = cls()
        out.G = geometry
        out.DM1 = data_matrix_1
        out.DM2 = data_matrix_2
        out.qi = qi1, qi2
        out.file = file.split('/')[-1]
        return out

    def __repr__(self):
        return f'MarsisRDR(file={self.file})'


marsis_headers = [
    'CENTRAL_FREQUENCY',
    'SLOPE',
    'SCET_FRAME_WHOLE',
    'SCET_FRAME_FRAC',
    'H_SCET_PAR',
    'VT_SCET_PAR',
    'VR_SCET_PAR',
    'DELTA_S_SCET_PAR',
    'NA_SCET_PAR',
    'GEOMETRY_EPHEMERIS_TIME',
    'GEOMETRY_EPOCH',
    'MARS_SOLAR_LONGITUDE',
    'MARS_SUN_DISTANCE',
    'ORBIT_NUMBER',
    'TARGET_NAME',
    'TARGET_SC_POSITION_VECTOR',
    'SPACECRAFT_ALTITUDE',
    'SUB_SC_LONGITUDE',
    'SUB_SC_LATITUDE',
    'TARGET_SC_VELOCITY_VECTOR',
    'TARGET_SC_RADIAL_VELOCITY',
    'TARGET_SC_TANG_VELOCITY',
    'LOCAL_TRUE_SOLAR_TIME',
    'SOLAR_ZENITH_ANGLE',
    'DIPOLE_UNIT_VECTOR',
    'MONOPOLE_UNIT_VECTOR',
]
