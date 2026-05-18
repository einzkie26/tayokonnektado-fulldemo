using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.Threading.RateLimiting;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;
using TayoKonnektado_project.Services;
using TayoKonnektado_project.Services.Security;

var builder = WebApplication.CreateBuilder(args);

//Add services to the container.

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
        options.JsonSerializerOptions.DictionaryKeyPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
        // Allow camelCase JSON keys (e.g. "endDate", "planId") to match PascalCase
        // C# properties (e.g. "EndDate", "PlanID") during deserialization.
        options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
        // Force all DateTime values to serialize with 'Z' (UTC marker) so the
        // frontend JavaScript correctly parses them as UTC before converting to PH time.
        options.JsonSerializerOptions.Converters.Add(new UtcDateTimeConverter());
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Enter 'Bearer' [space] and then your token",
        Name = "Authorization",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

//Database
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

//Identity
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    // Strong password policy
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = true;
    options.Password.RequiredLength = 12;
    options.Password.RequiredUniqueChars = 4;

    // Lockout policy for brute-force protection
    options.Lockout.AllowedForNewUsers = true;
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
})
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

//JWT Authentication
var jwtKey = Environment.GetEnvironmentVariable("JWT_KEY");
if (string.IsNullOrWhiteSpace(jwtKey))
    throw new InvalidOperationException("JWT secret key is not configured. Set JWT_KEY environment variable.");

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
    };
})
.AddGoogle(options =>
{
    options.ClientId = builder.Configuration["Google:ClientId"]!;
    options.ClientSecret = builder.Configuration["Google:ClientSecret"]!;
});

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

// Rate limiting for auth endpoints
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    options.AddPolicy("auth", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 20,
                Window = TimeSpan.FromMinutes(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                QueueLimit = 5
            }));
});

//Register Services
builder.Services.AddScoped<TayoKonnektado_project.Services.PayMongoService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.TokenService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.EmailService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.CustomerManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.TicketManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.PaymentManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.SubscriptionManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.StaffManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.DashboardService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.PlanManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.Admin.FAQManagementService>();
builder.Services.AddScoped<TayoKonnektado_project.Services.LoginAttemptService>();
builder.Services.AddHostedService<TayoKonnektado_project.Services.SubscriptionEndDateService>();
builder.Services.AddHostedService<TayoKonnektado_project.Services.PrepaidUsageService>();
builder.Services.AddHttpClient();
builder.Services.Configure<SecuritySettings>(builder.Configuration.GetSection("Security"));
builder.Services.AddSingleton<IpDeviceReputationService>();
builder.Services.AddHttpClient<PasswordBreachService>();

var app = builder.Build();

//Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowReactApp");

app.UseStaticFiles();
app.UseDefaultFiles();

if (app.Environment.IsDevelopment())
{
    //Skip HTTPS redirect in development
}
else
{
    app.UseHttpsRedirection();
}

app.UseAuthentication();
app.UseRateLimiter();
app.UseMiddleware<ActivityLoggingMiddleware>();
app.UseAuthorization();

app.MapControllers();

app.MapFallback(async context =>
{
    if (!context.Request.Path.StartsWithSegments("/api"))
    {
        context.Response.ContentType = "text/html";
        await context.Response.SendFileAsync(Path.Combine(app.Environment.WebRootPath, "index.html"));
    }
});

//seed Admin
using (var scope = app.Services.CreateScope())
{
    var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    await AdminSeeder.SeedAdminAsync(userManager, roleManager);
    await PlanSeeder.SeedPlansAsync(context);
}

app.Run();

/// <summary>
/// Ensures DateTime values round-trip as UTC (with 'Z' suffix) in JSON responses.
/// Without this, EF Core returns DateTime with Kind=Unspecified, causing ASP.NET to
/// omit the 'Z', which makes JavaScript treat the time as local instead of UTC.
/// </summary>
public class UtcDateTimeConverter : System.Text.Json.Serialization.JsonConverter<DateTime>
{
    public override DateTime Read(ref System.Text.Json.Utf8JsonReader reader, Type typeToConvert, System.Text.Json.JsonSerializerOptions options)
    {
        var dt = reader.GetDateTime();
        return DateTime.SpecifyKind(dt, DateTimeKind.Utc);
    }

    public override void Write(System.Text.Json.Utf8JsonWriter writer, DateTime value, System.Text.Json.JsonSerializerOptions options)
    {
        writer.WriteStringValue(DateTime.SpecifyKind(value, DateTimeKind.Utc));
    }
}
