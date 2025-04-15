# 🧱 Deploying to Multiple Regions Using Loops in Bicep — Made Simple

> **Bitesize Lesson 🍬**  
This quick guide is here to help *you* (yes, you!) understand what’s going on in the code inside this repo — especially if you’re new to Bicep.  
Also… let’s be honest, it’s a cheeky little reminder for **future me** when I forget how this works. 😅

---

## 🎡 What Are Bicep Loops?

Imagine you’re running a **global toy company** — and you’ve just launched a super smart teddy bear that tells bedtime stories. 🧸📖  
Now, to sell this toy in different countries, you need to set up **one Azure SQL Server per region**, because of those pesky (but important!) local data laws. Doing this one-by-one? Nah. That’s like manually making a new teddy for each kid. Way too much effort.

Instead, use **Bicep loops**, like your own personal automation elves. 🧙‍♂️✨  
They let you set it up once, and repeat it for each region, like magic.

---

## 🪣 Example 1: Deploying Storage Accounts from a List

Here’s a list of names you want for your storage accounts:

```bicep
param storageAccountNames array = [
  'saauditus'
  'saauditeurope'
  'saauditapac'
]
```

Use a loop to turn that list into real resources:

```bicep
resource storageAccountResources 'Microsoft.Storage/storageAccounts@2023-05-01' = [
  for storageAccountName in storageAccountNames: {
    name: storageAccountName
    location: resourceGroup().location
    kind: 'StorageV2'
    sku: {
      name: 'Standard_LRS'
    }
  }
]
```

🛠️ This is like saying: “Hey Bicep, take each name from that list and build me a storage account with it.”

---

## 🔢 Example 2: Looping with a Counter

No list? You can roll with numbers using `range()`:

```bicep
resource storageAccountResources 'Microsoft.Storage/storageAccounts@2023-05-01' = [
  for i in range(1,4): {
    name: 'sa${i}'  // creates sa1, sa2, sa3, sa4
    location: resourceGroup().location
    kind: 'StorageV2'
    sku: {
      name: 'Standard_LRS'
    }
  }
]
```

📏 `range(1,4)` starts at 1 and gives you 4 values (1 to 4). Handy when you just need a certain number of resources.

> ⚠️ The second number is a **count**, not an end number. `range(3,4)` gives you 3, 4, 5, 6.

---

## 🧭 Example 3: Deploying SQL Servers Across Locations

Say you want a SQL Server in each of these regions:

```bicep
param locations array = [
  'westeurope'
  'eastus2'
  'eastasia'
]
```

You can loop through and give each one a numbered name:

```bicep
resource sqlServers 'Microsoft.Sql/servers@2024-05-01-preview' = [
  for (location, i) in locations: {
    name: 'sqlserver-${i + 1}'
    location: location
    properties: {
      administratorLogin: administratorLogin
      administratorLoginPassword: administratorLoginPassword
    }
  }
]
```

This sets up `sqlserver-1`, `sqlserver-2`, and so on.  
💡 You add `+1` because loops start counting at 0, and that’s not very human-friendly.

---

## 🧪 Bonus Round: Filtering With Conditions Inside Loops

Sometimes you only want to deploy resources in specific situations. Like only for **Production** environments:

```bicep
param sqlServerDetails array = [
  {
    name: 'sqlserver-we'
    location: 'westeurope'
    environmentName: 'Production'
  }
  {
    name: 'sqlserver-eus2'
    location: 'eastus2'
    environmentName: 'Development'
  }
  {
    name: 'sqlserver-eas'
    location: 'eastasia'
    environmentName: 'Production'
  }
]

resource sqlServers 'Microsoft.Sql/servers@2024-05-01-preview' = [
  for sqlServer in sqlServerDetails: if (sqlServer.environmentName == 'Production') {
    name: sqlServer.name
    location: sqlServer.location
    properties: {
      administratorLogin: administratorLogin
      administratorLoginPassword: administratorLoginPassword
    }
    tags: {
      environment: sqlServer.environmentName
    }
  }
]
```

Only `Production` environments get deployed. The `Development` one? Skipped! 🚫  
This is super handy when managing multiple environments in a single template.

---

## 🎯 TL;DR

- 🌀 Use `for` loops to spin up **multiple resources** from arrays.
- 🔢 Use `range()` when you need to loop based on numbers.
- 🧾 Want to number stuff? Grab the index with `(item, i)`.
- 🎯 Filter your deployments inside loops with `if`.

---

Think of Bicep loops as your **cloud-building cheat code** — whether you’re helping others learn or leaving yourself a breadcrumb trail for later 🧠🍞.  
Now dive into the code and deploy like a pro! 🚀
