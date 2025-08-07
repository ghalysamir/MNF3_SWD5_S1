namespace Assignment_Session_10
{
    internal class Program
    {
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount(); 
            BankAccount account2 = new BankAccount("Ghaly Samir", "29811220123456", "01012345678", "Cairo", 15000);

            account1.ShowAccountDetails();
            Console.WriteLine();
            account2.ShowAccountDetails();

            Console.WriteLine();
            Console.WriteLine($"Account 2 National ID valid? {account2.IsValidNationalID()}");
            Console.WriteLine($"Account 2 Phone Number valid? {account2.IsValidPhoneNumber()}");
        }
    }
}





public class BankAccount
{
    // Constants and Readonly Fields
    public const string BankCode = "BNK001";
    public readonly DateTime CreatedDate;

    // Private Fields
    private int _accountNumber;
    private string _fullName;
    private string _nationalID;
    private string _phoneNumber;
    private string _address;
    private decimal _balance;

    // Static counter to auto-generate account numbers
    private static int _accountCounter = 1000;

    // Properties with Traditional Getters and Setters
    public string FullName
    {
        get
        {
            return _fullName;
        }
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Full name cannot be empty.");
            _fullName = value;
        }
    }

    public string NationalID
    {
        get
        {
            return _nationalID;
        }
        set
        {
            if (value.Length != 14 || !ulong.TryParse(value, out _))
                throw new ArgumentException("National ID must be exactly 14 digits.");
            _nationalID = value;
        }
    }

    public string PhoneNumber
    {
        get
        {
            return _phoneNumber;
        }
        set
        {
            if (value.Length != 11 || !value.StartsWith("01"))
                throw new ArgumentException("Phone number must be 11 digits and start with '01'.");
            _phoneNumber = value;
        }
    }

    public string Address
    {
        get
        {
            return _address;
        }
        set
        {
            _address = value;
        }
    }

    public decimal Balance
    {
        get
        {
            return _balance;
        }
        set
        {
            if (value < 0)
                throw new ArgumentException("Balance cannot be negative.");
            _balance = value;
        }
    }

    // Default Constructor
    public BankAccount()
    {
        CreatedDate = DateTime.Now;
        _accountNumber = ++_accountCounter;
        FullName = "Default Name";
        NationalID = "00000000000000";
        PhoneNumber = "01000000000";
        Address = "N/A";
        Balance = 0;
    }

    // Parameterized Constructor
    public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
    {
        CreatedDate = DateTime.Now;
        _accountNumber = ++_accountCounter;
        FullName = fullName;
        NationalID = nationalID;
        PhoneNumber = phoneNumber;
        Address = address;
        Balance = balance;
    }

    // Overloaded Constructor (without balance)
    public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
        : this(fullName, nationalID, phoneNumber, address, 0)
    {
    }

    // Methods
    public void ShowAccountDetails()
    {
        Console.WriteLine("======= Account Info =======");
        Console.WriteLine($"Account Number: {_accountNumber}");
        Console.WriteLine($"Full Name     : {_fullName}");
        Console.WriteLine($"National ID   : {_nationalID}");
        Console.WriteLine($"Phone Number  : {_phoneNumber}");
        Console.WriteLine($"Address       : {_address}");
        Console.WriteLine($"Balance       : {_balance} EGP");
        Console.WriteLine($"Bank Code     : {BankCode}");
        Console.WriteLine($"Created Date  : {CreatedDate}");
        Console.WriteLine("============================");
    }

    public bool IsValidNationalID()
    {
        return _nationalID.Length == 14 && ulong.TryParse(_nationalID, out _);
    }

    public bool IsValidPhoneNumber()
    {
        return _phoneNumber.Length == 11 && _phoneNumber.StartsWith("01");
    }
}



