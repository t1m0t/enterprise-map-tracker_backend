const baseFilePath = Bun.env.SCRAPPING_DATA_PATH;
const villagesFilePath = `${baseFilePath}/villages.json`;
const tahsilsFilePath = `${baseFilePath}/tahsil.json`;

const villageFile = Bun.file(villagesFilePath);
const tahsilFile = Bun.file(tahsilsFilePath);

const villageData = await villageFile.json();
const tahsilData = await tahsilFile.json();

const result = [];
const header = [
	"name",
	"population",
	"km2",
	"village_code",
	"census_code",
	"tahsil",
	"district",
];
result.push(header);

villageData.forEach((item) => {
	const part = [
		item.village_name,
		item.village_population,
		item.village_km2_area,
		item.village_code,
		item.village_census_code,
		item.tahsil_name,
	];

	for (const tahsil of tahsilData) {
		if (tahsil.tahsil_name === item.tahsil_name) {
			part.push(tahsil.district_name);
			break;
		}
	}

	result.push(part);
});

// Convert to CSV
const csvContent = result.map(row => row.map(cell => `"${String(cell ?? '').replace(/"/g, '""')}"`).join(",")).join("\n");

// Write to file
const outputPath = `${baseFilePath}/villages.csv`;
await Bun.write(outputPath, csvContent);

console.log(`CSV written to ${outputPath}`);
