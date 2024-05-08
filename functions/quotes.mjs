export const handler = async () => {

    const quotes = [
      "The only way to do great work is to love what you do. - Steve Jobs",
      "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
      "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
      "The way to get started is to quit talking and begin doing. - Walt Disney",
      "It does not matter how slowly you go as long as you do not stop. - Confucius"
    ];

    function getRandomQuote() {
      const randomIndex = Math.floor(Math.random() * quotes.length);
      return quotes[randomIndex];
    }


console.log(getRandomQuote());

    const response = {
        status: '200',
        body:getRandomQuote(),
    };

    return response;
};
