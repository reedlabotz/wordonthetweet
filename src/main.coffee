@analyzer

@analyzer = new Analyzer('AFINN-111-emo.txt')

analyzer.addToQueue "The cool thing about Hulu Plus is that I pay for it but also get ads and I can't watch Wilfred on my iPad hey wait that's not so cool.", (text, sentiment) -> 
	console.log text, sentiment

analyzer.addToQueue "Could @hulu please remind me what my #HuluPlus subscription is for?!?!? Why do I pay $$ for ads and can't watch messages?!?!?", (text, sentiment) -> 
	console.log text, sentiment
