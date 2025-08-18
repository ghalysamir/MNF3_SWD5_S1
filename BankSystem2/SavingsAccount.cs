namespace BankSystem2;

partial class Program
{
    class SavingsAccount : Account
    {
        public decimal InterestRate { get; private set; }

        public SavingsAccount(Customer owner, decimal initialBalance, decimal rate)
            : base(owner, initialBalance)
        {
            InterestRate = rate;
        }

        public void ApplyMonthlyInterest()
        {
            var interest = Balance * InterestRate / 12;
            Deposit(interest);
            Transactions.Add($"Interest applied: {interest}");
        }
    }
}
