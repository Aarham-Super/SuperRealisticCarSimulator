# SuperRealisticCarSimulator

SuperRealisticCarSimulator is a .NET 10 ASP.NET Core website for a realistic driving simulator brand by Aarham.

## Downloads

- EXE: `/download/SuperRealisticCarSimulator.exe`
- ZIP: `/download/SuperRealisticCarSimulator.zip`
- GitHub: <https://github.com/Aarham-Super/SuperRealisticCarSimulator>

## Features

- Realistic simulator-themed landing page
- Custom logo and favicon
- Separate EXE and ZIP download links
- Copyright text: "All made by Aarham"
- Apache License 2.0

## Configuration

This repo uses two config files:

- `appsettings.json` for local secret values
- `appsettingsgit.json` for GitHub-safe values with secrets removed

`appsettings.json` is ignored by Git so private values stay on your machine.

## Databases

- Primary database: MySQL
- Backup database: SQLite
- Schema files: `sql/mysql/01_core.sql` and `sql/sqlite/01_backup.sql`
- The backup database is meant to keep the site functioning if MySQL is unavailable
- When the main MySQL system is healthy again, it can resume as the primary source

## Build

```powershell
dotnet build
dotnet run --project SuperRealisticCarSimulator.csproj
```

## Notes

- Target framework: `net10.0`
- The site is hosted as an ASP.NET Core web app
- The `artifacts/` folder is used for the published Windows EXE build output

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE).
