--create database PizzeriaLuigi

create table Pizza(
IdPizza int identity (1,1) not null,
Nome nvarchar(50) not null,
Prezzo decimal(18,2) not null,
constraint PK_PIZZA primary key (IdPizza),
constraint Chk_PrezzoPizza check (Prezzo>0)
);

create table Ingrediente(
IdIngrediente int identity (1,1) not null,
Nome nvarchar(50) not null,
Costo decimal(18,2) not null,
ScorteMagazzino int not null,
constraint PK_INGREDIENTE primary key (IdIngrediente),
constraint Chk_CostoIngredeinte check (Costo>0),
constraint Chk_ScorteMagazzino check (ScorteMagazzino>=0)
);

create table PizzaIngrediente(
IdPizza int not null Constraint FK_IdPizza foreign key references Pizza(IdPizza),
IdIngrediente int not null constraint FK_IdIngrediente foreign key references Ingrediente(IdIngrediente)
);

--INSERT
insert into Pizza values ('Margherita', 5)
insert into Pizza values ('Bufala', 7)
insert into Pizza values ('Diavola', 6)
insert into Pizza values ('Quattro Stagioni', 6.5)
insert into Pizza values ('Porcini', 7)
insert into Pizza values ('Dioniso', 8)
insert into Pizza values ('Ortolana', 8)
insert into Pizza values ('Patate e Salsiccia', 6)
insert into Pizza values ('Pomodorini', 6)
insert into Pizza values ('Quattro Formaggi', 7.5)
insert into Pizza values ('Caprese', 7.5)
insert into Pizza values ('Zeus', 7.5)

insert into Ingrediente values ('Pomodoro', 1.5, 10)
insert into Ingrediente values ('Mozzarella', 1.5, 20)
insert into Ingrediente values ('Mozzarella di Bufala', 2, 5)
insert into Ingrediente values ('Spianata Piccante', 2.5, 8)
insert into Ingrediente values ('Funghi', 3, 15)
insert into Ingrediente values ('Carciofi', 2.5, 8)
insert into Ingrediente values ('Prosciutto Cotto', 1, 30)
insert into Ingrediente values ('Olive', 4, 10)
insert into Ingrediente values ('Funghi Porcini', 4, 18)
insert into Ingrediente values ('Stracchino', 1.5, 10)
insert into Ingrediente values ('Spack', 1.5, 8)
insert into Ingrediente values ('Rucola', 0.8, 12)
insert into Ingrediente values ('Grana', 2, 5)
insert into Ingrediente values ('Verdure di Stagione', 1, 30)
insert into Ingrediente values ('Patate', 1.5, 20)
insert into Ingrediente values ('Salsiccia', 3, 15)
insert into Ingrediente values ('Pomodorini', 0.8, 20)
insert into Ingrediente values ('Ricotta', 4.5, 11)
insert into Ingrediente values ('Provola', 1.5, 7)
insert into Ingrediente values ('Gorgonzola', 1.5, 13)
insert into Ingrediente values ('Pomodoro fresco', 0.9, 25)
insert into Ingrediente values ('Basilico', 0.5, 32)
insert into Ingrediente values ('Bresaola', 2, 6)

insert into PizzaIngrediente values (1,1)
insert into PizzaIngrediente values (1,2)
insert into PizzaIngrediente values (2,1)
insert into PizzaIngrediente values (2,3)
insert into PizzaIngrediente values (3,1)
insert into PizzaIngrediente values (3,2)
insert into PizzaIngrediente values (3,4)
insert into PizzaIngrediente values (4,1)
insert into PizzaIngrediente values (4,2)
insert into PizzaIngrediente values (4,5)
insert into PizzaIngrediente values (4,6)
insert into PizzaIngrediente values (4,7)
insert into PizzaIngrediente values (4,8)
insert into PizzaIngrediente values (5,1)
insert into PizzaIngrediente values (5,2)
insert into PizzaIngrediente values (5,9)
insert into PizzaIngrediente values (6,1)
insert into PizzaIngrediente values (6,2)
insert into PizzaIngrediente values (6,10)
insert into PizzaIngrediente values (6,11)
insert into PizzaIngrediente values (6,12)
insert into PizzaIngrediente values (6,13)
insert into PizzaIngrediente values (7,1)
insert into PizzaIngrediente values (7,2)
insert into PizzaIngrediente values (7,14)
insert into PizzaIngrediente values (8,1)
insert into PizzaIngrediente values (8,15)
insert into PizzaIngrediente values (8,16)
insert into PizzaIngrediente values (9,1)
insert into PizzaIngrediente values (9,17)
insert into PizzaIngrediente values (9,18)
insert into PizzaIngrediente values (10,1)
insert into PizzaIngrediente values (10,19)
insert into PizzaIngrediente values (10,20)
insert into PizzaIngrediente values (10,13)
insert into PizzaIngrediente values (11,1)
insert into PizzaIngrediente values (11,21)
insert into PizzaIngrediente values (11,22)
insert into PizzaIngrediente values (12,1)
insert into PizzaIngrediente values (12,23)
insert into PizzaIngrediente values (12,12)

select * from Pizza
select * from Ingrediente
select * from PizzaIngrediente

--QUERY
Select * from Pizza p where p.Prezzo > 6

Select * from Pizza p where p.Prezzo in (select Max(p.Prezzo) from Pizza p)

select p.Nome
from Pizza p
where p.IdPizza not in (select p.IdPizza from Pizza p join PizzaIngrediente ping on p.IdPizza=ping.IdPizza 
						join Ingrediente i on i.IdIngrediente=ping.IdIngrediente where i.Nome='Pomodoro');

select p.Nome
from Pizza p
where p.IdPizza in (select p.IdPizza from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza 
						join Ingrediente i on i.IdIngrediente=pin.IdIngrediente where i.Nome='Funghi' 
						OR i.Nome='Funghi Porcini');

--STORED PROCEDURE
create procedure InserimentoPizza
@NomePizza nvarchar(50),
@PrezzoPizza decimal(18,2)

AS

insert into Pizza values (@NomePizza, @PrezzoPizza)
GO

execute InserimentoPizza 'Marinara', 4

select * from Pizza
--------------------------------------
create procedure InserimentoIngredientePizza
@NomePizza nvarchar(50),
@NomeIngrediente nvarchar(50)

AS
declare @IDPIZZA int
select @IDPIZZA = IdPizza from Pizza where Nome = @NomePizza
declare @IDINGREDIENTE int
select @IDINGREDIENTE = IdIngrediente from Ingrediente where Nome = @NomeIngrediente
insert into PizzaIngrediente values (@IDPIZZA,@IDINGREDIENTE)
GO
----------------------------------------
create procedure AggiornamentoPrezzo
@NomePizza nvarchar(50),
@NuovoPrezzo decimal(18,2)

AS
begin

declare @IDPIZZA int
select @IDPIZZA = p.IdPizza from Pizza p where p.Nome = @NomePizza

UPDATE Pizza set Prezzo = @NuovoPrezzo where IdPizza = @IDPIZZA
end
GO
-----------------------------------------
create procedure EliminazioneIngrediente
@NomePizza nvarchar(50),
@NomeIngrediente nvarchar(50)

AS
begin
declare @IDPIZZA int
select @IDPIZZA = IdPizza from Pizza where Nome = @NomePizza
declare @IDINGREDIENTE int
select @IDINGREDIENTE = IdIngrediente from Ingrediente where Nome = @NomeIngrediente

DELETE from PizzaIngrediente where PizzaIngrediente.IdIngrediente in (select i.IdIngrediente 
		from Ingrediente i where i.Nome = @NomeIngrediente) and PizzaIngrediente.IdPizza in 
		(select p.IdPizza from Pizza p where p.Nome = @NomePizza)
end
GO
--------------------------------------
create procedure IncrementoPrezzo
@NomeIngrediente nvarchar(50)

AS
begin
declare @idIngrediente int

set @idIngrediente = (select i.IdIngrediente from Ingrediente i where i.Nome=@nomeIngrediente)
update Pizza set Prezzo = Prezzo*10/100 where Pizza.IdPizza in (select pin.IdPizza from PizzaIngrediente pin where pin.IdIngrediente=@idIngrediente)
end
GO

--FUNCTION
create function ListinoPrezziPizze()
returns table
as
return
select p.Nome, p.Prezzo
from Pizza p

select * from ListinoPrezziPizze()
-----------------------------------------
create function ListinoConUnIngrediente(@NomeIngrediente nvarchar(50))
returns table

AS
return 
select p.Nome , p.Prezzo, i.Nome
from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
			join Ingrediente i on i.IdIngrediente=pin.IdIngrediente
			where i.Nome=@NomeIngrediente

select * from ListinoConUnIngrediente ('Grana')
---------------------------------------------
create function ListinoSenzaIngrediente(@nomeIngrediente nvarchar(25))
returns table 

AS
return 

select p.Nome , p.Prezzo
from Pizza p 
where p.IdPizza not in (select p.IdPizza from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					join Ingrediente i on i.IdIngrediente=pin.IdIngrediente 
					where i.Nome = @nomeIngrediente)
----------------------------------------------
create function CalcoloPizzeConIngrediente(@nomeIngrediente nvarchar(50))
returns int
as
Begin
declare @numeroPizze int

select @numeroPizze=count(*)
from Pizza p 
where p.IdPizza in (select p.IdPizza from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					join Ingrediente i on i.IdIngrediente=pin.IdIngrediente 
					where i.Nome = @nomeIngrediente)

return @numeroPizze
end

select dbo.CalcoloPizzeConIngrediente('Funghi')
-------------------------------------------------
create function CalcoloPizzeSenzaIngredient(@CodiceIngrediente int)
returns int
as
begin
declare @numeroPizze int

select @numeroPizze=count(*)
from Pizza p 
where p.IdPizza not in (select p.IdPizza from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					join Ingrediente i on i.IdIngrediente=pin.IdIngrediente 
					where i.IdIngrediente = @CodiceIngrediente)

return @numeroPizze
end

select dbo.CalcoloPizzeSenzaIngrediente(23)
----------------------------------------
create function NumeroIngredientiPizza(@NomePizza nvarchar(50))
returns int
as
begin
declare @NumeroIngredienti int
select @NumeroIngredienti = COUNT(*)
from Ingrediente i
where i.IdIngrediente IN (select pin.IdIngrediente
						   from PizzaIngrediente pin
						   JOIN Pizza p on p.IdPizza = pin.IdPizza
						   where p.Nome = @NomePizza)

return @NumeroIngredienti
end

select dbo.NumeroIngredientiPizza('Margherita')