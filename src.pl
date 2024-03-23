:-consult('data.pl').

%1
list_orders(CustUserName, Orders) :-
	customer(CustID, CustUserName),
	list_orders_helper(CustID, [], Orders).

list_orders_helper(CustID, Acc, Orders) :-
	order(CustID, OrderID, Items),
	Order = order(CustID, OrderID, Items),
	\+ is_member(Order, Acc),
	!,
	list_orders_helper(CustID, [Order|Acc], Orders).

list_orders_helper(_, Orders, Orders).

is_member(Item, [Item|_]).
is_member(Item, [_|Tail]) :-
	is_member(Item, Tail).

%2

countOrdersOfCustomer(CustUserName, Count) :-
	list_orders(CustUserName, Orders),
	list_len(Orders, Count).

list_len([], 0).
list_len([_|Tail], Length) :-
	list_len(Tail, TailLength),
	Length is TailLength + 1.

%3
getItemsInOrderById(CustomerName,OrderId,Items):-
    customer(CustomerId,CustomerName),
    order(CustomerId,OrderId,Items),!.


% Define a predicate to get the number of items in a customer's order
% question 4
num_items_in_order(CustomerName, OrderID, NumItems) :-
    % Get the customer's ID based on the given name
    customer(CustomerID, CustomerName),
    % Check if the order exists for the customer
    order(CustomerID, OrderID, Items),
    % Count the number of items in the list
    length(Items, NumItems).

% Define a predicate to calculate the price of a customer's order
% question 5
calcPriceOfOrder(CustomerName, OrderID, TotalPrice) :-
    % Get the customer's ID based on the given name
    customer(CustomerID, CustomerName),
    % Check if the order exists for the customer
    order(CustomerID, OrderID, Items),
    % Calculate the total price
    calculateTotalPrice(Items, 0, TotalPrice).

% Base case for calculating total price (when items list is empty)
calculateTotalPrice([], Acc, Acc).

% Recursive case for calculating total price
calculateTotalPrice([Item|Rest], Acc, TotalPrice) :-
    % Get the price of the current item
    item(Item, _, Price),
    % Add the price to the accumulator
    NewAcc is Acc + Price,
    % Continue with the rest of the items
    calculateTotalPrice(Rest, NewAcc, TotalPrice).


%question 6
isBoycott(ItemOrCompanyName) :-
    % Check if the company is boycotted
    boycott_company(ItemOrCompanyName, _).


isBoycott(ItemName) :-
    % Get the company of the item
    item(ItemName, Company, _),
    % Check if the company is boycotted
    boycott_company(Company, _).

%question 7
whyToBoycott(ItemOrCompanyName, Justification) :-
    % Check if the item is boycotted
    item(ItemOrCompanyName, Company, _),
    % Check if the company is boycotted and get the justification
    boycott_company(Company, Justification).

whyToBoycott(ItemOrCompanyName, Justification) :-
    % Check if the company itself is boycotted and get the justification
    boycott_company(ItemOrCompanyName, Justification).


%8

%...



%9
recursiveFunctionReplaceBoycottItemsFromAnOrder([H|T],Acc,ResultList):-
    item(H,ComName,_),
    boycott_company(ComName,_),
    alternative(H,Alter),
    recursiveFunctionReplaceBoycottItemsFromAnOrder(T, [Alter|Acc],ResultList).
 

recursiveFunctionReplaceBoycottItemsFromAnOrder([H|T],Acc,ResultList):-
    item(H,ComName,_),
    \+ boycott_company(ComName,_),
    recursiveFunctionReplaceBoycottItemsFromAnOrder(T, [H|Acc],ResultList).



recursiveFunctionReplaceBoycottItemsFromAnOrder(_,ResultList,ResultList).


replaceBoycottItemsFromAnOrder(Username, OrderID, NewList):-
    customer(CustID,Username),
    order(CustID,OrderID,OldList),
    recursiveFunctionReplaceBoycottItemsFromAnOrder(OldList,[],NewList),
    !.


%10

calcPriceAfterReplacingBoycottItemsFromAnOrder(Username, OrderID, NewList, TotalPrice):-
    replaceBoycottItemsFromAnOrder(Username,OrderID,NewList),
    calculateTotalPrice(NewList,0,TotalPrice).


%11
getTheDifferenceInPriceBetweenItemAndAlternative(BoycottItem, A, DiffPrice):-
    item(BoycottItem,_,Price1),
    alternative(BoycottItem,A),
    item(A,_,Price2),
    DiffPrice is Price1 - Price2.



%12


%...
