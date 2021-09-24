create database Pizzeria;

create table Pizza(
IDPizza int identity(1,1) primary key,
Nome varchar(50) not null,
Prezzo decimal(4,2) check (Prezzo > 0) not null
);

create table Ingrediente(
IDIngrediente int identity(1,1) primary key,
Nome varchar(50) not null,
Costo decimal(4,2) check (Costo > 0) not null,
Scorte int check (Scorte >= 0)
);

create table IngredientePizza(
IDPizza int,
IDIngrediente int,
constraint FK_Pizza foreign key (IDPizza) references Pizza(IDPizza),
constraint FK_Ingrediente foreign key (IDIngrediente) references Ingrediente(IDIngrediente),
constraint PK_IngredientePizza primary key (IDPizza,IDIngrediente)
);

---Popolazione tabelle---
insert into Pizza values('Margherita',5)
insert into Pizza values('Bufala',7)
insert into Pizza values('Diavola',6)
insert into Pizza values('Quattro stagioni',6.50)
insert into Pizza values('Porcini',7)
insert into Pizza values('Dioniso',8)
insert into Pizza values('Ortolana',8)
insert into Pizza values('Patate e salsiccia',6)
insert into Pizza values('Pomodorini',6)
insert into Pizza values('Quattro formaggi',7.50)
insert into Pizza values('Caprese',7.50)

insert into Ingrediente values('pomodoro',1,150)
insert into Ingrediente values('mozzarella',1.50,150)
insert into Ingrediente values('mozzarella di bufala',4,70)
insert into Ingrediente values('spianata piccante',3,20)
insert into Ingrediente values('funghi',1.50,100)
insert into Ingrediente values('carciofi',1,80)
insert into Ingrediente values('cotto',1.20,110)
insert into Ingrediente values('olive',1,70)
insert into Ingrediente values('stracchino',2,30)
insert into Ingrediente values('speck',1.60,40)
insert into Ingrediente values('rucola',1,50)
insert into Ingrediente values('grana',3,40)
insert into Ingrediente values('verdure di stagione',2,100)
insert into Ingrediente values('patate',1,100)
insert into Ingrediente values('salsiccia',3,50)
insert into Ingrediente values('pomodorini',2,60)
insert into Ingrediente values('ricotta',2,50)
insert into Ingrediente values('provola',3.50,50)
insert into Ingrediente values('gorgonzola',2,50)
insert into Ingrediente values('pomodoro fresco',1,70)
insert into Ingrediente values('basilico',1,100)
insert into Ingrediente values('funghi porcini',3,50)
insert into Ingrediente values('bresaola',2.50,40)

--update Ingrediente set Nome = 'carciofi' where IDIngrediente = 6

insert into IngredientePizza values (1,1)
insert into IngredientePizza values (1,2)
insert into IngredientePizza values (2,1)
insert into IngredientePizza values (2,3)
insert into IngredientePizza values (3,1)
insert into IngredientePizza values (3,2)
insert into IngredientePizza values (3,4)
insert into IngredientePizza values (4,1)
insert into IngredientePizza values (4,2)
insert into IngredientePizza values (4,5)
insert into IngredientePizza values (4,6)
insert into IngredientePizza values (4,7)
insert into IngredientePizza values (4,8)
insert into IngredientePizza values (5,1)
insert into IngredientePizza values (5,2)
insert into IngredientePizza values (5,22)
insert into IngredientePizza values (6,1)
insert into IngredientePizza values (6,2)
insert into IngredientePizza values (6,9)
insert into IngredientePizza values (6,10)
insert into IngredientePizza values (6,11)
insert into IngredientePizza values (6,12)
insert into IngredientePizza values (7,1)
insert into IngredientePizza values (7,2)
insert into IngredientePizza values (7,13)
insert into IngredientePizza values (8,2)
insert into IngredientePizza values (8,14)
insert into IngredientePizza values (8,15)
insert into IngredientePizza values (9,2)
insert into IngredientePizza values (9,16)
insert into IngredientePizza values (9,17)
insert into IngredientePizza values (10,2)
insert into IngredientePizza values (10,18)
insert into IngredientePizza values (10,19)
insert into IngredientePizza values (10,12)
insert into IngredientePizza values (11,2)
insert into IngredientePizza values (11,20)
insert into IngredientePizza values (11,21)


--Query

--1
select *
from Pizza
where Prezzo > 6

--2
select * 
from Pizza
where Prezzo = (select max(Prezzo) from Pizza)

--3
select *
from Pizza 
where IDPizza not in (select p.IDPizza
						from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
									join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
						where i.Nome = 'pomodoro') --considero pizze bianche quelle col pomodoro fresco

--4
select p.IDPizza, p.Nome, p.Prezzo
from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
				join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
where i.Nome like 'funghi%'

--stored procedures

Create procedure InserisciPizza
@nome varchar(50),
@prezzo decimal(4,2)
AS
insert into Pizza values (@nome,@prezzo)
GO

execute InserisciPizza @nome='Zeus', @prezzo = 7.50

Create procedure AssegnaIngrediente
@nomepizza varchar(50),
@nomeingr varchar(50)
AS
begin
	begin try
		insert into IngredientePizza values ((select p.IDPizza from Pizza p where p.Nome=@nomepizza),
		(select i.IDIngrediente from Ingrediente i where i.Nome=@nomeingr))
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO

execute AssegnaIngrediente @nomepizza='Zeus', @nomeingr='mozzarella'
execute AssegnaIngrediente @nomepizza='Zeus', @nomeingr='bresaola'
execute AssegnaIngrediente @nomepizza='Zeus', @nomeingr='rucola'

Create procedure PrezzoPizza
@nome varchar(50),
@prezzo decimal(4,2)
AS
begin try
	update Pizza set Prezzo = @prezzo where Nome = @nome
end try
begin catch
	select ERROR_MESSAGE()
end catch
GO

execute PrezzoPizza @nome='Zeus', @prezzo = 9

create procedure EliminaIngredienteDaPizza
@nomepizza varchar(50),
@nomeingr varchar(50)
AS
begin try
	delete from IngredientePizza where IDPizza = (select IDPizza from Pizza where Nome = @nomepizza)
									and IDIngrediente = (select IDIngrediente from Ingrediente where Nome = @nomeingr)
end try
begin catch
	select ERROR_MESSAGE()
end catch
GO

execute EliminaIngredienteDaPizza @nomepizza = 'Dioniso', @nomeingr = 'rucola'

create procedure AumentaPrezzoPizza
@nomeingr varchar(50)
AS
begin try
	update Pizza set Prezzo = Prezzo + Prezzo*0.1 where IDPizza in 
							(select p.IDPizza 
							from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
										join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
							where i.Nome = @nomeingr)
end try
begin catch
	select ERROR_MESSAGE()
end catch
GO

execute AumentaPrezzoPizza @nomeingr = 'bresaola'

create function ListinoPizze()
returns Table
AS
Return
select *
from Pizza

select *
from dbo.ListinoPizze()
order by Nome

create function PizzeConIngrediente(@nomeingr nvarchar(50))
returns Table
As
return 
select p.Nome, p.Prezzo
from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
			join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
where i.Nome = @nomeingr

select * from dbo.PizzeConIngrediente('bresaola')

create function NumPizzeConIngrediente(@nomeingr nvarchar(50))
returns int
As
begin
declare @output int
select @output = COUNT(p.IDPizza)
from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
			join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
where i.Nome = @nomeingr
return @output
end

select dbo.NumPizzeIngrediente('mozzarella')

create function NumPizzeSenzaIngrediente(@nomeingr nvarchar(50))
returns int
As
begin
declare @output int
select @output = COUNT(IDPizza)
from Pizza 
where IDPizza not in (select p.IDPizza
						from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
								join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
						where i.Nome = @nomeingr)
return @output
end

select dbo.NumPizzeSenzaIngrediente('pomodoro')

create function NumIngredientiPizza(@nomepizza nvarchar(50))
returns int
As
begin
declare @output int 
select @output = COUNT(inp.IDIngrediente) 
from Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
where p.Nome = @nomepizza
group by inp.IDPizza
return @output
end

select dbo.NumIngredientiPizza('Quattro formaggi')

--vista senza string_agg
create View Menu(Nome, Prezzo, Ingrediente)
as (	
select  p.Nome, p.Prezzo, i.Nome
from  Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
			join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
)

--Con string_agg

create View MenuStringa(Nome, Prezzo, Ingrediente)
as (	
select  p.Nome, p.Prezzo, STRING_AGG(i.Nome,',')
from  Pizza p join IngredientePizza inp on p.IDPizza = inp.IDPizza
			join Ingrediente i on i.IDIngrediente = inp.IDIngrediente
group by p.Nome, p.Prezzo)





