namespace BankSystem2;

partial class Program
{
    abstract class Account
    {
        private static int counter = 100;
        public int AccountNumber { get; private set; }
        public decimal Balance { get; protected set; }
        public DateTime DateOpened { get; private set; }
        public Customer Owner { get; private set; }
        public List<string> Transactions { get; } = new();

        public Account(Customer owner, decimal initialBalance)
        {
            AccountNumber = counter++;
            Balance = initialBalance;
            DateOpened = DateTime.Now;
            Owner = owner;
            owner.Accounts.Add(this);
        }

        public virtual void Deposit(decimal amount)
        {
            Balance += amount;
            Transactions.Add($"Deposited {amount}");
        }

        public virtual bool Withdraw(decimal amount)
        {
            if (Balance >= amount)
            {
                Balance -= amount;
                Transactions.Add($"Withdrew {amount}");
                return true;
            }
            return false;
        }
    }
}
