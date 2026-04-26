# Backend Service Organization

## Overview
The backend has been reorganized to separate business logic into dedicated service classes, making the code easier to find, maintain, and test.

## New Structure

```
Services/
├── Admin/                                    # Admin-specific services
│   ├── CustomerManagementService.cs         # Customer CRUD operations
│   ├── TicketManagementService.cs           # Ticket management & replies
│   ├── PaymentManagementService.cs          # Payment approval & processing
│   ├── SubscriptionManagementService.cs     # Subscription management
│   ├── StaffManagementService.cs            # Staff account management
│   ├── DashboardService.cs                  # Dashboard stats & reports
│   ├── PlanManagementService.cs             # Plan management
│   └── FAQManagementService.cs              # FAQ management
├── EmailService.cs                          # Email sending
├── PayMongoService.cs                       # Payment gateway integration
├── TokenService.cs                          # JWT token generation
└── AdminSeeder.cs                           # Database seeding
```

## Service Responsibilities

### CustomerManagementService
- Get all customers with subscriptions and balances
- Get customer by ID
- Update customer information
- Delete customer

### TicketManagementService
- Get all support tickets
- Update ticket status
- Reply to tickets (with email notifications)
- Archive/unarchive tickets

### PaymentManagementService
- Get all payments
- Approve/reject payments
- Process PayMongo payments
- Send receipt emails
- Archive/unarchive/delete payments

### SubscriptionManagementService
- Get all subscriptions
- Update subscription details
- Delete subscriptions

### StaffManagementService
- Get all staff members
- Create new staff accounts
- Update staff information
- Delete staff accounts

### DashboardService
- Get dashboard statistics
- Get active services
- Get all invoices
- Get payment method statistics
- Get activity logs

### PlanManagementService
- Get all plans with subscriber counts
- Update plan details
- Delete plans

### FAQManagementService
- Get all FAQs
- Create new FAQs
- Update FAQ content
- Delete FAQs

## Benefits

1. **Easy to Find**: Each service has a clear, descriptive name
2. **Single Responsibility**: Each service handles one domain area
3. **Testable**: Services can be unit tested independently
4. **Maintainable**: Changes to one area don't affect others
5. **Reusable**: Services can be used by multiple controllers
6. **Clean Controller**: AdminController is now much smaller and cleaner

## Usage in Controller

The AdminController now uses dependency injection to access these services:

```csharp
public class AdminController : ControllerBase
{
    private readonly CustomerManagementService _customerService;
    private readonly TicketManagementService _ticketService;
    // ... other services

    public AdminController(
        CustomerManagementService customerService,
        TicketManagementService ticketService,
        // ... other services
    )
    {
        _customerService = customerService;
        _ticketService = ticketService;
        // ... assign other services
    }

    [HttpGet("customers")]
    public async Task<IActionResult> GetCustomers() 
        => Ok(await _customerService.GetAllCustomersAsync());
}
```

## Service Registration

All services are registered in `Program.cs`:

```csharp
builder.Services.AddScoped<CustomerManagementService>();
builder.Services.AddScoped<TicketManagementService>();
builder.Services.AddScoped<PaymentManagementService>();
// ... other services
```

## Next Steps

To complete the refactoring:
1. Update AdminController to use all service methods
2. Consider creating similar service structures for CustomerController
3. Add unit tests for each service
4. Add XML documentation comments to service methods
