namespace BankSystem2;

partial class Program
{
    class CurrentAccount : Account
    {
        public decimal OverdraftLimit { get; private set; }

        public CurrentAccount(Customer owner, decimal initialBalance, decimal overdraft)
            : base(owner, initialBalance)
        {
            OverdraftLimit = overdraft;
        }

        public override bool Withdraw(decimal amount)
        {
            if (Balance + OverdraftLimit >= amount)
            {
                Balance -= amount;
                Transactions.Add($"Withdrew {amount} (Overdraft allowed)");
                return true;
            }
            return false;
        }
    }
}
