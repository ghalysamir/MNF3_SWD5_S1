namespace BankSystem2;

partial class Program
{

    #region Main Method
    static void Main(string[] args)
    {
        Bank bank = new Bank("National Bank", "001");
        bool exit = false;

        while (!exit)
        {
            Console.WriteLine("\n--- Bank System Menu ---");
            Console.WriteLine("1. Add Customer");
            Console.WriteLine("2. Add Account");
            Console.WriteLine("3. Deposit");
            Console.WriteLine("4. Withdraw");
            Console.WriteLine("5. Transfer");
            Console.WriteLine("6. Show Customer Total Balance");
            Console.WriteLine("7. Show Bank Report");
            Console.WriteLine("0. Exit");

            Console.Write("Choose option: ");
            string option = Console.ReadLine();

            switch (option)
            {
                case "1":
                    Console.Write("Enter full name: ");
                    string name = Console.ReadLine();

                    Console.Write("Enter national ID: ");
                    string nid = Console.ReadLine();

                    Console.Write("Enter DOB (yyyy-mm-dd): ");
                    DateTime dob = DateTime.Parse(Console.ReadLine());

                    var customer = bank.AddCustomer(name, nid, dob);
                    Console.WriteLine($"Customer added with ID: {customer.CustomerId}");
                    break;

                case "2":
                    Console.Write("Enter customer ID: ");
                    int custId = int.Parse(Console.ReadLine());
                    Console.WriteLine("1. Savings Account");
                    Console.WriteLine("2. Current Account");
                    string accType = Console.ReadLine();

                    Console.Write("Enter initial balance: ");
                    decimal initBal = decimal.Parse(Console.ReadLine());

                    Customer c = bank.GetCustomer(custId);
                    if (c == null) { Console.WriteLine("Customer not found!"); break; }

                    if (accType == "1")
                    {
                        Console.Write("Enter interest rate: ");
                        decimal rate = decimal.Parse(Console.ReadLine());
                        var acc = bank.OpenAccount(new SavingsAccount(c, initBal, rate));
                        Console.WriteLine($"Savings account created #{acc.AccountNumber}");
                    }
                    else
                    {
                        Console.Write("Enter overdraft limit: ");
                        decimal overdraft = decimal.Parse(Console.ReadLine());
                        var acc = bank.OpenAccount(new CurrentAccount(c, initBal, overdraft));
                        Console.WriteLine($"Current account created #{acc.AccountNumber}");
                    }
                    break;

                case "3":
                    Console.Write("Enter account number: ");
                    int accNoD = int.Parse(Console.ReadLine());
                    Console.Write("Enter amount: ");
                    decimal amtD = decimal.Parse(Console.ReadLine());
                    bank.Deposit(accNoD, amtD);
                    Console.WriteLine("Deposit successful!");
                    break;

                case "4":
                    Console.Write("Enter account number: ");
                    int accNoW = int.Parse(Console.ReadLine());
                    Console.Write("Enter amount: ");
                    decimal amtW = decimal.Parse(Console.ReadLine());
                    bank.Withdraw(accNoW, amtW);
                    Console.WriteLine("Withdraw attempted!");
                    break;

                case "5":
                    Console.Write("Enter source account number: ");
                    int from = int.Parse(Console.ReadLine());
                    Console.Write("Enter destination account number: ");
                    int to = int.Parse(Console.ReadLine());
                    Console.Write("Enter amount: ");
                    decimal amtT = decimal.Parse(Console.ReadLine());
                    bank.Transfer(from, to, amtT);
                    Console.WriteLine("Transfer attempted!");
                    break;

                case "6":
                    Console.Write("Enter customer ID: ");
                    int cid = int.Parse(Console.ReadLine());
                    Console.WriteLine($"Total Balance: {bank.GetCustomerTotalBalance(cid)}");
                    break;

                case "7":
                    bank.PrintBankReport();
                    break;

                case "0":
                    exit = true;
                    break;

                default:
                    Console.WriteLine("Invalid option!");
                    break;
            }
        }
    }

    #endregion
}
