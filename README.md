# Spiritus: A openaq data crawler

Spiritus is a data crawler & processor based on bash. It crawls data from [openaq](https://openaq.org/) directly from (AWS)[https://openaq-data-archive.s3.amazonaws.com/].

## Project struckture

'''bash
.
├── README.md
└── src
    ├── crawler.sh
    ├── run.sh
    └── processor.sh
'''

## Workflow

Spiritus work in two steps: Download the data from [openaq](https://openaq.org/) directly from (AWS)[https://openaq-data-archive.s3.amazonaws.com/] and process the data by mesurement parameter and locations.

### Data Crawler

All data will be saved in a automaticly created data directory. The data scope can be defined by the 'LOCATION_ID' list in 'src/crawler.sh'.

:::callout{
# Waring
This can  download up to 350 files to your system, roughly 1.5 MB of data.
}

The data will be downloaded in compemised format but will be unpack automaticaly. In a last step all data will be merged to a single data file (CSV).

### Processor

The processor filter the data by mesurement parameters and location ID. Both can be defines in list in 'src/processor.sh'.

## Run the Workflow

Download this repository with 'git' and navigate to the project directory.

'''bash
git clone https://github.com/nilsrechberger/spiritus.git
cd spiritus
''' 

The complete workflow can be run by 'src/run.sh' which combines the data crawling and processing in one file.

'''bash
. src/run.sh
'''

### Shortcuts

Its not nessecary to run 'src/run.sh' every time after a adjustment. Both files 'src/crawler.sh' and 'src/processor' can be run idenpendatly.

'''bash
. src/crawler.sh
. src/processor.sh
'''
