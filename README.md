# Markowitz Modern Portfolio

## About

This git repository contains code with data inserted into the program to educate and generate small insights and ideas about the Markowitz Modern Portfolio model.

### Objective

This code is developed in order to observe the best-fitting asset portfolio based on its historical data.

#### The theory

Based on the same idea, one asset's evaluation is analyzed by its expected return and variance in order to visualize risk and return.
As each independent asset is correlated, the portfolio follows the same path.

* Return:

Consider "x" as the portfolio return over the asset "i" and "w" as the considered weight (percent of the total amount available for investment) for the asset "i".

![image](https://user-images.githubusercontent.com/120825682/220669044-e790709a-9638-42d9-8824-383db77a3068.png)

There is no magical explanation here, just by using the weighted average formula, the portfolio return data can be found.

* Variance:

Consider "σ" as the asset "i" variance and "ρ" the correlation between two assets ("i" and "j").

![image](https://user-images.githubusercontent.com/120825682/220670572-813a9830-d994-4c5b-874b-352a3c480bc3.png)

There will be combined asset variance among its correlation with other assets in order to evaluate portfolio risk.

* Sharpe Index:

A known index used to quantify the risk versus return of an asset or a portfolio.

![image](https://user-images.githubusercontent.com/120825682/220673884-a64acc26-a2ff-48ab-877f-be4999011d93.png)

### Example 

Using the maximized portfolio example attached to this git, the following happens.

* Return:

E(x) = 0.469079 *  0.47 + 0.004905 * 0.26 + 0.526016 * 0.59

E(X) = 0.5453

* Variance:

σx = 0.4691^2 * 0.36 + 0.0049^2 * 5.45 + 0.5260^2 * 0.33 + 0.4691 * 0.0049 * (0.36^(1/2)) * (5.45^(1/2)) * 0.6953 + 0.4691 * 0.5260 * (0.36^(1/2)) * (0.33^(1/2)) * 0.4707 + 0.0049 * 0.5260 * (5.45^(1/2)) * (0.33^(1/2)) * 0.4258

σx = 0.2419

* Sharpe Index:

SH = (0.5453 - 0.1375) / 0.2419

SH = 1.6856

### Portfolio chart 

![image](https://user-images.githubusercontent.com/120825682/220675975-3b3d7767-8d9b-4e2e-a973-5d04678b3e85.png)


