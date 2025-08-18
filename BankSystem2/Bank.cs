namespace BankSystem2;

partial class Program
{
    class Bank
    {
        public string Name { get; private set; }
        public string BranchCode { get; private set; }
        private List<Customer> Customers = new();

        public Bank(string name, string code)
        {
            Name = name;
            BranchCode = code;
        }
        public Customer GetCustomer(int customerId) => Customers.FirstOrDefault(c => c.CustomerId == customerId);


        public Customer AddCustomer(string fullName, string nid, DateTime dob)
        {
            var c = new Customer(fullName, nid, dob);
            Customers.Add(c);
            return c;
        }

        public Account OpenAccount(Account account) => account;

        public void Deposit(int accountNumber, decimal amount) =>
            FindAccount(accountNumber)?.Deposit(amount);

        public void Withdraw(int accountNumber, decimal amount) =>
            FindAccount(accountNumber)?.Withdraw(amount);

        public void Transfer(int from, int to, decimal amount)
        {
            var src = FindAccount(from);
            var dest = FindAccount(to);
            if (src.Withdraw(amount))
                dest.Deposit(amount);
        }

        public decimal GetCustomerTotalBalance(int customerId)
        {
            var c = Customers.First(x => x.CustomerId == customerId);
            return c.Accounts.Sum(a => a.Balance);
        }

        public void PrintBankReport()
        {
            Console.WriteLine($"Bank Report for {Name}");
            foreach (var c in Customers)
            {
                Console.WriteLine($"Customer: {c.FullName}");
                foreach (var acc in c.Accounts)
                    Console.WriteLine($"  Account #{acc.AccountNumber}: {acc.Balance}");
            }
        }

        private Account FindAccount(int accNo) =>
            Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accNo);
    }
}
