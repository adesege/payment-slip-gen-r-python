# Highridge Construction Company Payment Slip Generator

## Overview

This project contains Python and R implementations for generating weekly payment slips for Highridge Construction Company workers.

## Requirements

- Python 3.7+
- R 4.0+
- R packages: jsonlite

## Usage

### Python Version

```bash
python payment_slips.py
```

### R Version

```bash
Rscript payment_slips.R
```

## Features

- Dynamic generation of 400+ workers
- Automated employee level classification
- Exception handling
- JSON output for data persistence

## Employee Level Classification

- **A1**: Salary between $10,000 and $20,000
- **A5-F**: Salary between $7,500 and $30,000 AND Female gender
- **Standard**: All other cases

## Output

Both versions generate JSON files in output/ directory containing payment slip data.
