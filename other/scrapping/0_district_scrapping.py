import asyncio
import json
import os
from crawl4ai import JsonCssExtractionStrategy, AsyncWebCrawler, CrawlerRunConfig


async def main():
    BASE_URL = os.getenv("SCRAPPING_BASE_URL")
    if not BASE_URL:
        raise ValueError("SCRAPPING_BASE_URL environment variable is not set.")

    schema = {
        "name": "Extract District data",
        "baseSelector": "table tr:nth-child(n+2)",
        "fields": [
            {"name": "district_name", "selector": "td:nth-child(2) a", "type": "text"},
            {
                "name": "district_url",
                "selector": "td:nth-child(2) a",
                "type": "attribute",
                "attribute": "href",
            },
            {"name": "census_code", "selector": "td:nth-child(3)", "type": "text"},
            {
                "name": "number_of_villages",
                "selector": "td:nth-child(4)",
                "type": "text",
            },
        ],
    }

    run_conf = CrawlerRunConfig(
        extraction_strategy=JsonCssExtractionStrategy(schema, verbose=True)
    )

    async with AsyncWebCrawler(verbose=True) as crawler:
        jsonRes = []
        result = await crawler.arun(
            url=os.getenv("SCRAPPING_BASE_URL"), config=run_conf
        )
        if not result.success:
            print("Crawl failed:", result.error_message)
            return

        data = json.loads(result.extracted_content)
        jsonRes = data
        await asyncio.sleep(30)

    if jsonRes:
        with open("ressources/districts.json", "w") as f:
            # overwrite the file
            f.write(json.dumps(jsonRes, indent=2))


if __name__ == "__main__":
    asyncio.run(main())
