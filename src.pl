:- dynamic item/3.
:- dynamic alternative/2.
:- dynamic boycott_company/2.
:-consult('data.pl').

% 1
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

% 2

countOrdersOfCustomer(CustUserName, Count) :-
	list_orders(CustUserName, Orders),
	list_len(Orders, Count).

list_len([], 0).
list_len([_|Tail], Length) :-
	list_len(Tail, TailLength),
	Length is TailLength + 1.


% 3
getItemsInOrderById(CustomerName,OrderId,Items):-
    customer(CustomerId,CustomerName),
    order(CustomerId,OrderId,Items),!.


% 4

getNumOfItems(CustUserName, OrderID, ItemsCount) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items),
	list_len(Items, ItemsCount).



% 5
calcPriceOfOrder(CustUserName, OrderID, TotalPrice) :-
	customer(CustID, CustUserName),
	order(CustID, OrderID, Items),
	items_price(Items, TotalPrice).

items_price([], 0).
items_price([Head|Tail], TotalPrice) :-
	item(Head, _, HeadPrice),
	items_price(Tail, TailPrice),
	TotalPrice is HeadPrice + TailPrice.



% 6

isBoycott(ItemName) :-
	item(ItemName, CompanyName, _),
	boycott_company(CompanyName, _).
isBoycott(CompanyName) :-
	boycott_company(CompanyName, _).



% 7

whyToBoycott(CompanyName, Justification) :-
	boycott_company(CompanyName, Justification).
whyToBoycott(ItemName, Justification) :-
	item(ItemName, CompanyName, _),
	boycott_company(CompanyName, Justification).



% 8
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


% 9
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


% 10

calcPriceAfterReplacingBoycottItemsFromAnOrder(Username, OrderID, NewList, TotalPrice):-
    replaceBoycottItemsFromAnOrder(Username,OrderID,NewList),
    calculateTotalPrice(NewList,0,TotalPrice).


% 11
getTheDifferenceInPriceBetweenItemAndAlternative(BoycottItem, A, DiffPrice):-
    item(BoycottItem,_,Price1),
    alternative(BoycottItem,A),
    item(A,_,Price2),
    DiffPrice is Price1 - Price2.






% 12

add_item(ItemName, CompanyName, Price) :- assert(item(ItemName, CompanyName, Price)).
remove_item(ItemName, CompanyName, Price) :- retract(item(ItemName, CompanyName, Price)).

add_alternative(ItemName, AlternativeItem) :- assert(alternative(ItemName, AlternativeItem)).
remove_alternative(ItemName, AlternativeItem) :- retract(alternative(ItemName, AlternativeItem)).

add_boycott_company(CompanyName, Justification) :- assert(boycott_company(CompanyName, Justification)).
remove_boycott_company(CompanyName, Justification) :- retract(boycott_company(CompanyName, Justification)).
