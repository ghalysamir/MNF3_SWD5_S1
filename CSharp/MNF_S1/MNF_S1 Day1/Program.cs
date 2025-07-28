namespace MNF_S1_Day1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
            Console.Write("Input the first number: ");
            double num1 = Convert.ToDouble(Console.ReadLine());

            Console.Write("Input the second number: ");
            double num2 = Convert.ToDouble(Console.ReadLine());

            string choice = "";
            bool validChoice = false;

            while (!validChoice)
            {
                Console.WriteLine("What do you want to do with those numbers?");
                Console.WriteLine("[A]dd");
                Console.WriteLine("[S]ubtract");
                Console.WriteLine("[M]ultiply");
                Console.Write("Your choice: ");
                choice = Console.ReadLine().ToLower();

                switch (choice)
                {
                    case "a":
                        Console.WriteLine($"{num1} + {num2} = {num1 + num2}");
                        validChoice = true;
                        break;
                    case "s":
                        Console.WriteLine($"{num1} - {num2} = {num1 - num2}");
                        validChoice = true;
                        break;
                    case "m":
                        Console.WriteLine($"{num1} * {num2} = {num1 * num2}");
                        validChoice = true;
                        break;
                    default:
                        Console.WriteLine("Invalid option, please try again.\n");
                        break;
                }
            }

            Console.WriteLine("Press any key to close");
            Console.ReadKey();
        }
    }
}
