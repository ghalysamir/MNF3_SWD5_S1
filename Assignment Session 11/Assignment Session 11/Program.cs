using System;
using System.Collections.Generic;

namespace BankExample
{

    public class BankAccount
    {
        public string AccountNumber { get; set; }
        public string AccountHolderName { get; set; }
        public decimal Balance { get; set; }

        public BankAccount(string accountNumber, string accountHolderName, decimal balance)
        {
            AccountNumber = accountNumber;
            AccountHolderName = accountHolderName;
            Balance = balance;
        }

       
        public virtual decimal CalculateInterest()
        {
            return 0;
        }

    
        public virtual void ShowAccountDetails()
        {
            Console.WriteLine($"Account Number: {AccountNumber}");
            Console.WriteLine($"Account Holder: {AccountHolderName}");
            Console.WriteLine($"Balance: {Balance:C}");
        }
    }


    public class SavingAccount : BankAccount
    {
        public decimal InterestRate { get; set; }

        public SavingAccount(string accountNumber, string accountHolderName, decimal balance, decimal interestRate)
            : base(accountNumber, accountHolderName, balance)
        {
            InterestRate = interestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest Rate: {InterestRate}%");
        }
    }

   
    public class CurrentAccount : BankAccount
    {
        public decimal OverdraftLimit { get; set; }

        public CurrentAccount(string accountNumber, string accountHolderName, decimal balance, decimal overdraftLimit)
            : base(accountNumber, accountHolderName, balance)
        {
            OverdraftLimit = overdraftLimit;
        }

        public override decimal CalculateInterest()
        {
            return 0; 
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit:C}");
        }
    }


    class Program
    {
        static void Main(string[] args)
        {
      
            SavingAccount savingAcc = new SavingAccount("SA001", "Ali Ahmed", 5000m, 5m);
            CurrentAccount currentAcc = new CurrentAccount("CA001", "Sara Mohamed", 3000m, 1000m);

          
            List<BankAccount> accounts = new List<BankAccount> { savingAcc, currentAcc };

        
            foreach (var account in accounts)
            {
                account.ShowAccountDetails();
                Console.WriteLine($"Interest: {account.CalculateInterest():C}");
                Console.WriteLine(new string('-', 30));
            }

            Console.ReadLine();
        }
    }
}
