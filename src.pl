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


%  4
num_items_in_order(CustomerName, OrderID, ItemsCount) :-
    customer(CustID, CustUserName),
    order(CustID, OrderID, Items),
    list_len(Items, ItemsCount).


%  5
calcPriceOfOrder(CustomerName, OrderID, TotalPrice) :-
    customer(CustomerID, CustomerName),
    order(CustomerID, OrderID, Items),
    calculateTotalPrice(Items, 0, TotalPrice).

calculateTotalPrice([], Acc, Acc).

calculateTotalPrice([Item|Rest], Acc, TotalPrice) :-
    item(Item, _, Price),
    NewAcc is Acc + Price,
    calculateTotalPrice(Rest, NewAcc, TotalPrice).


% 6
isBoycott(ItemOrCompanyName) :-
    boycott_company(ItemOrCompanyName, _).


isBoycott(ItemName) :-
    item(ItemName, Company, _),
    boycott_company(Company, _).

% 7
whyToBoycott(ItemOrCompanyName, Justification) :-
    item(ItemOrCompanyName, Company, _),
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
