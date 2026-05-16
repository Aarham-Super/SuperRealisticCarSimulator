using Microsoft.Extensions.Configuration.Json;
using System.IO.Compression;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.Sources.Insert(0, new JsonConfigurationSource
{
    Path = "appsettingsgit.json",
    Optional = true,
    ReloadOnChange = true
});

// Add services to the container.
builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();
app.MapRazorPages()
   .WithStaticAssets();

app.MapGet("/download/SuperRealisticCarSimulator.zip", () =>
{
    var zipStream = new MemoryStream();

    using (var archive = new ZipArchive(zipStream, ZipArchiveMode.Create, leaveOpen: true))
    {
        CreateEntry(archive, "README.txt", """
        SuperRealisticCarSimulator

        Made by Aarham.
        This download package is a website demo build for the simulator landing page.
        Replace these placeholder files with the real game installer and asset bundle when ready.
        """);

        CreateEntry(archive, "LegalNotice.txt", """
        SuperRealisticCarSimulator

        Copyright (c) 2026 Aarham.
        All rights reserved.

        This product is provided for demonstration and simulation purposes only.
        """);

        CreateEntry(archive, "BuildInfo.txt", """
        Project: SuperRealisticCarSimulator
        Framework: .NET 10 ASP.NET Core
        Expected style: realistic driving simulator website
        """);
    }

    zipStream.Position = 0;
    return Results.File(zipStream.ToArray(), "application/zip", "SuperRealisticCarSimulator.zip");
});

app.MapGet("/download/SuperRealisticCarSimulator.exe", () =>
{
    var exePath = Path.Combine(app.Environment.ContentRootPath, "artifacts", "exe", "SuperRealisticCarSimulator.exe");
    if (!File.Exists(exePath))
    {
        return Results.NotFound("The Windows EXE has not been published yet.");
    }

    return Results.File(exePath, "application/octet-stream", "SuperRealisticCarSimulator.exe");
});

app.Run();

static void CreateEntry(ZipArchive archive, string path, string content)
{
    var entry = archive.CreateEntry(path, CompressionLevel.Fastest);
    using var writer = new StreamWriter(entry.Open(), Encoding.UTF8);
    writer.Write(content);
}
