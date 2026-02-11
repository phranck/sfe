#!/usr/bin/env python3
"""Setup script for sfe package."""
from setuptools import setup
import os

def get_data_files():
    """Collect all data files that need to be installed."""
    data_files = []
    
    # Base files
    base_files = ['names.txt', 'info.txt']
    data_files.append(('share/sfe', base_files))
    
    # Variant directories with svgs.txt
    for variant in ['monochrome', 'hierarchical']:
        variant_file = os.path.join(variant, 'svgs.txt')
        if os.path.exists(variant_file):
            data_files.append((f'share/sfe/{variant}', [variant_file]))
    
    return data_files

setup(
    data_files=get_data_files(),
)
