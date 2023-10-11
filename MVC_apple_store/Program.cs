using FluentValidation;
using FluentValidation.AspNetCore;
using BusinessLogic.Interfaces;
using BusinessLogic.Services;
using Microsoft.EntityFrameworkCore;
using MVC_apple_store.Services;
using Infrastructure;
using BusinessLogic;

var builder = WebApplication.CreateBuilder(args);
string dbHost = Environment.GetEnvironmentVariable("DB_HOST");
string dbName = Environment.GetEnvironmentVariable("DB_NAME");
string dbPass = Environment.GetEnvironmentVariable("DB_PASS");
string dbUser = Environment.GetEnvironmentVariable("DB_USER");

//string connectionString = builder.Configuration.GetConnectionString("RemoteDB");
string connectionString = $"Data Source={dbHost};Initial Catalog={dbName};Persist Security Info=True;User ID={dbUser};Password={dbPass}";

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddDbContext(connectionString);

// repository 
builder.Services.AddRepository();

// services
builder.Services.AddScoped<IPhoneService, PhoneService>();
builder.Services.AddScoped<ICartService, CartService>();

// auto mapper
builder.Services.AddAutoMapper();

// fluent validators
builder.Services.AddValidators();

// session configurations
builder.Services.AddDistributedMemoryCache();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromSeconds(10);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder.Services.AddHttpContextAccessor();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.UseSession();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run("http://0.0.0.0:9999");
