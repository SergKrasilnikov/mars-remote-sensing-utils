import numpy as np


def generate_geography_string_for_marsis_rdr(rdr):
    """ Generate the geography string for the footprint of the given MARSIS radargram.

    The geometry is multi-line: the orbits are split into multiple parts if the longitudes of two consecutive points are
    more than 15 degrees apart.

    """

    lon = rdr.G.loc[:, 'SUB_SC_LONGITUDE'].values
    lat = rdr.G.loc[:, 'SUB_SC_LATITUDE'].values

    # subtract 360 from longitudes that are >= 180
    lon = np.where(lon >= 180, lon - 360, lon)

    geography_entry = f'SRID=949900;MULTILINESTRING(({lon[0]} {lat[0]},'

    prev_x = lon[0]

    for x, y in zip(lon[1:], lat[1:]):
        # if the absolute difference between two successive points is greater than 15 degrees,
        # then we split the line into 2 multilines
        if abs(x - prev_x) < 15:
            geography_entry += f'{x} {y},'
        else:
            geography_entry = geography_entry[:-1] + f'),({x} {y},'

        prev_x = x

    geography_entry = geography_entry[:-1] + '))'

    return geography_entry


def generate_geography_string_for_sharad_image(img):
    """ Generate the geography string for the footprint of the given SHARAD radargram. """

    # subtract 360 from longitudes that are >= 180
    # img.G.loc[img.G.loc[:, 'LONGITUDE'] >= 180, 'LONGITUDE'] -= 360

    lon = img.G.loc[:, 'LONGITUDE'].values
    lat = img.G.loc[:, 'LATITUDE'].values

    # subtract 360 from longitudes that are >= 180
    lon = np.where(lon >= 180, lon - 360, lon)

    geography_entry = f'SRID=949900;MULTILINESTRING(({lon[0]:.4f} {lat[0]:.4f},'

    prev_x = lon[0]

    for x, y in zip(lon[1:], lat[1:]):
        # if the absolute difference between two successive points is greater than 15 degrees,
        # then we split the line into 2 multilines
        if abs(x - prev_x) < 10:
            geography_entry += f'{x:.4f} {y:.4f},'
        else:
            geography_entry = geography_entry[:-1] + f'),({x:.4f} {y:.4f},'

        prev_x = x

    geography_entry = geography_entry[:-1] + '))'

    return geography_entry


def generate_sql_insert_statement_for_marsis_rdr(rdr, url):
    """ Generate an INSERT statement that adds given MARSIS radargram footprint to the database. """

    o = rdr.G.loc[0, 'ORBIT_NUMBER']
    e = rdr.G.loc[0, 'GEOMETRY_EPOCH']
    s = rdr.G.loc[:, 'SOLAR_ZENITH_ANGLE'].median()
    q = '{}{}'.format(*rdr.qi)
    g = generate_geography_string_for_marsis_rdr(rdr)

    return f"INSERT INTO marsis_footprints VALUES ({o}, '{e}', {s:.2f}, '{q}', '{g}', '{url}');"


def generate_sql_insert_statement_for_sharad_image(img, url):
    """ Generate an INSERT statement that adds given SHARAD radargram footprint to the database. """

    o = img.orbit
    ob = img.observation
    e = img.G.loc[0, 'TIME']
    s = img.G.loc[:, 'SZA'].median()
    g = generate_geography_string_for_sharad_image(img)

    return f"INSERT INTO sharad_footprints VALUES ({o}, {ob}, '{e}', {s:.2f}, '{g}', '{url}');"


def generate_sql_insert_statement_for_nomenclature(df):
    """ Generate an INSERT statement that adds nomenclature from a given DataFrame to the database. """

    q = 'INSERT INTO nomenclature VALUES ('

    for i, row in df.iterrows():
        # escape single quotes to not break PostgreSQL syntax: replace with double single quotes
        name = row['name'].replace("'", "''")
        origin = row['origin'].replace("'", "''")
        ethnicity = row['ethnicity'].replace("'", "''") if isinstance(row['ethnicity'], str) else 'nan'
        quad_code = f"{row['quad_code'][:2].upper()}-{row['quad_code'][2:]}" if isinstance(row['quad_code'],
                                                                                           str) else 'nan'

        q += f"'{name}', '{row['clean_name']}', '{row['approvaldt']}', "
        q += f"'{origin}', {row['diameter']}, "
        q += f"'SRID=949900;POINT({row['center_lon_180']} {row['center_lat']})', "
        q += f"{row['center_lon_180']}, {row['center_lat']}, '{row['type']}', "
        q += f"'{row['code']}', {row['min_lon_180']}, {row['max_lon_180']}, "
        q += f"{row['min_lat']}, {row['max_lat']}, '{ethnicity}', "
        q += f"'{row['continent']}', '{row['quad_name']}', '{quad_code}', "
        q += f"'{row['link']}'), ("

    return q[:-3] + ';'


def generate_sql_insert_statement_for_quadrants(df):
    """ Generate an INSERT statement that adds quadrants from a given DataFrame to the database. """

    q = 'INSERT INTO quadrants VALUES ('

    for i, row in df.iterrows():
        q += f"'{row['quad_code']}', '{row['quad_name']}', "
        q += f"'SRID=949900;{row['geometry']}', "
        q += f"'{row['map_url']}'), ("

    return q[:-3] + ';'
