# Spiritus: An OpenAQ Data Crawler and Processor

Spiritus is a **data crawler and processor** implemented entirely in **Bash**. It downloads air quality data directly from the [**OpenAQ**](https://openaq.org/) **Data** on [**AWS**](https://openaq-data-archive.s3.amazonaws.com/).

## Project Structure

```bash
.
├── README.md         # This file
└── src
    ├── crawler.sh    # Responsible for downloading and merging the data.
    ├── run.sh        # Executes the complete workflow (Crawling and Processing).
    └── processor.sh  # Responsible for filtering the merged data.
```

## Workflow

The Spiritus workflow is divided into two main steps:

1. **Data Crawling**: Downloading the compressed OpenAQ data from the AWS S3 bucket, followed by unpacking and merging it into a single CSV file.
2. **Data Processing**: Filtering the merged data based on specific measurement parameters and locations (Location IDs).

### 1\. Data Crawler (`src/crawler.sh`)

The crawler performs the following steps:

* All downloaded files are automatically saved in a newly created **`data`** directory.
* The **data scope** (which files to download) can be defined using the **`LOCATION_ID`** list in the **`src/crawler.sh`** file.
* The data is downloaded in a compressed format but is **automatically unpacked**.
* In a final step, all unpacked data is merged into a single **CSV data file**.

> **ATTENTION: Data Volume Warning**
>
> Depending on the configuration, this process can download **up to 350 files**, occupying roughly **1.5 GB** of data on your system.

### 2\. Processor (`src/processor.sh`)

The processor filters the merged main CSV file:

* The filtering is done by **measurement parameters** (e.g., `pm25`, `o3`) and **Location ID**.
* Both the desired parameters and Location IDs can be defined in the lists located within the **`src/processor.sh`** file.

## Running the Workflow

The complete workflow can be initiated using the **`src/run.sh`** file, which combines and executes both the crawler and the processor sequentially.

1. **Clone the repository and navigate to the project directory:**

<!-- end list -->

```bash
git clone https://github.com/nilsrechberger/spiritus.git
cd spiritus
```

2. **Start the complete workflow:**

<!-- end list -->

```bash
./src/run.sh
```

### Shortcuts for Independent Execution

It is **not necessary** to execute `src/run.sh` every time after making adjustments. Both the crawler and the processor scripts can be run **independently** when needed. This allows for quick iteration if you only need to re-process data without re-downloading, or vice versa.

To run the components separately:

```bash
# Execute only the Data Crawler (Downloads, unpacks, and merges data)
./src/crawler.sh

# Execute only the Processor (Filters existing data)
./src/processor.sh
```
