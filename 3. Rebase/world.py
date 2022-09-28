"""
Moduel world.py
"""
import math
import typing

def cartesian_to_spherical(
    x: float, 
    y: float, 
    z: float) -> typing.Tuple[float, float, float]:

    r = math.sqrt(x**2 + y**2 + z**2)
    theta = math.atan(y / x)
    phi = math.atan(math.sqrt(x**2 + y**2) / z)

    return (r, theta, phi)
