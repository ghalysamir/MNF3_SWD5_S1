namespace BankSystem2;

partial class Program
{
    class Customer
    {
        private static int counter = 1;
        public int CustomerId { get; private set; }
        public string FullName { get; private set; }
        public string NationalId { get; private set; }
        public DateTime DateOfBirth { get; private set; }
        public List<Account> Accounts { get; private set; } = new();

        public Customer(string name, string nid, DateTime dob)
        {
            CustomerId = counter++;
            FullName = name;
            NationalId = nid;
            DateOfBirth = dob;
        }
    }
}
