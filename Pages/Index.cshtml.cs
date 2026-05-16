using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace SuperRealisticCarSimulator.Pages;

public class IndexModel : PageModel
{
    public int CurrentYear { get; private set; }
    public string BuildSize { get; private set; } = string.Empty;
    public string DownloadExeUrl { get; private set; } = string.Empty;
    public string DownloadZipUrl { get; private set; } = string.Empty;

    public void OnGet()
    {
        CurrentYear = DateTime.UtcNow.Year;
        BuildSize = "EXE + ZIP";
        DownloadExeUrl = "/download/SuperRealisticCarSimulator.exe";
        DownloadZipUrl = "/download/SuperRealisticCarSimulator.zip";
    }
}
