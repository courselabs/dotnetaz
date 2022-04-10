using System.Net;

namespace Courselabs.QueueWorker;

public class Worker : BackgroundService
{
    private readonly IConfiguration _config;
    private readonly ILogger _logger;

    public Worker(IConfiguration config, ILogger<Worker> logger)
    {
        _config = config;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var host = Dns.GetHostName();
        var cachePath = _config["Paths:Cache"];
        var dbPath = _config["Paths:Database"];
        var tmpPath = _config["Paths:Temp"];
        new List<string>{cachePath, dbPath, tmpPath}.ForEach(x => Directory.CreateDirectory(x));

        _logger.LogInformation($"Worker started. Environment: {_config["App:Environment"]}. Using paths - Cache: {cachePath}; Database: {dbPath}; Temp:  {tmpPath}");
        while (!stoppingToken.IsCancellationRequested)
        {
            var now = DateTime.UtcNow;
            _logger.LogDebug($"Worker writing data at: {now}");
            await File.WriteAllTextAsync(Path.Combine(cachePath, "app.cache"), $"Cache updated at: {now}, by: {host}");
            await File.WriteAllTextAsync(Path.Combine(dbPath, "app.db"), $"Db updated at: {now}, by: {host}");
            await File.WriteAllTextAsync(Path.Combine(tmpPath, Guid.NewGuid().ToString().Substring(0,6)), $"Temp file written at: {now}, by: {host}");
            
            var sleep = _config.GetValue<int>("App:SleepMilliseconds", 3000);
            _logger.LogDebug($"Worker sleeping for: {sleep}ms");
            await Task.Delay(sleep, stoppingToken);
        }
        _logger.LogInformation("Worker exiting");
    }
}
