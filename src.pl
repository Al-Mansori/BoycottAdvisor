:-consult('data.pl').
:- dynamic item/3.
:- dynamic alternative/2.
:- dynamic boycott_company/2.

% 1. List all orders of a specific customer (as a list)

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



% 2. Get the number of orders of a specific customer given customer id.

countOrdersOfCustomer(CustUserName, Count) :-
	list_orders(CustUserName, Orders),
	list_len(Orders, Count).

list_len([], 0).
list_len([_|Tail], Length) :-
	list_len(Tail, TailLength),
	Length is TailLength + 1.



% 3. List all items in a specific customer order given customer id and order id.

getItemsInOrderById(CustUserName, OrderID, Items) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items).



% 4. Get the num of items in a specific customer order given customer Name and order id.

getNumOfItems(CustUserName, OrderID, ItemsCount) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items),
	list_len(Items, ItemsCount).



% 5. Calculate the price of a given order given Customer Name and order id

calcPriceOfOrder(CustUserName, OrderID, TotalPrice) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items),
	items_price(Items, TotalPrice).

items_price([], 0).
items_price([Head|Tail], TotalPrice) :-
	item(Head, _, HeadPrice),
	items_price(Tail, TailPrice),
	TotalPrice is HeadPrice + TailPrice.



% 6. Given the item name or company name, determine whether we need to boycott or not.

isBoycott(ItemName) :-
	item(ItemName, CompanyName, _),
	boycott_company(CompanyName, _).
isBoycott(CompanyName) :-
	boycott_company(CompanyName, _).



% 7. Given the company name or an item name, find the justification why you need to boycott this company/item.

whyToBoycott(CompanyName, Justification) :-
	boycott_company(CompanyName, Justification).
whyToBoycott(ItemName, Justification) :-
	item(ItemName, CompanyName, _),
	boycott_company(CompanyName, Justification).



% 8. Given an username and order ID, remove all the boycott items from this order.

removeBoycottItemsFromAnOrder(CustUserName, OrderID, NewItems) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items),
	remove_boycott_items(Items, NewItems).

remove_boycott_items([], []).
remove_boycott_items([Head|Tail], NewTail) :- 
	item(Head, CompanyName, _),
	boycott_company(CompanyName, _),
	!,
	remove_boycott_items(Tail, NewTail).
remove_boycott_items([Head|Tail], [Head|NewTail]) :-
	remove_boycott_items(Tail, NewTail).



% 9. Given an username and order ID, update the order such that all boycott items are replaced by an alternative (if exists).

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

% 10. Given an username and order ID, calculate the price of the order after replacing all boycott items by its alternative (if it exists).

calcPriceAfterReplacingBoycottItemsFromAnOrder(CustUserName, OrderID, NewItems, NewPrice) :-
	replaceBoycottItemsFromAnOrder(CustUserName, OrderID, NewItems),
	items_price(NewItems, NewPrice).



% 11. calculate the difference in price between the boycott item and its alternative.

getTheDifferenceInPriceBetweenItemAndAlternative(BoycottItem, AltItem, Diff) :-
	alternative(BoycottItem, AltItem),
	item(BoycottItem, _, BoycottPrice),
	item(AltItem, _, AltPrice),
	Diff is BoycottPrice - AltPrice.



% 12. Insert/Remove (1)item, (2)alternative and (3)new boycott company to/from the knowledge base.

add_item(ItemName, CompanyName, Price) :- assert(item(ItemName, CompanyName, Price)).
remove_item(ItemName, CompanyName, Price) :- retract(item(ItemName, CompanyName, Price)).

add_alternative(ItemName, AlternativeItem) :- assert(alternative(ItemName, AlternativeItem)).
remove_alternative(ItemName, AlternativeItem) :- retract(alternative(ItemName, AlternativeItem)).

add_boycott_company(CompanyName, Justification) :- assert(boycott_company(CompanyName, Justification)).
remove_boycott_company(CompanyName, Justification) :- retract(boycott_company(CompanyName, Justification)).

