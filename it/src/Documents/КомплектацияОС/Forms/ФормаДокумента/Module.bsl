
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗадатьПараметрыДляКомплектующихВСоставе(ОтборОсновноеСредство)
	
	ПараметрыГраницы = Новый Массив(2);
	ПараметрыГраницы[0] = Объект.Дата;
	ПараметрыГраницы[1] = ВидГраницы.Включая;
	МоментАнализа = Новый(Тип("Граница"),ПараметрыГраницы);
	
	КомплектующиеВСоставеОС.Параметры.УстановитьЗначениеПараметра("ИдентификаторКомпьютера", ОтборОсновноеСредство); 	//Комиссаров: 24/07/2013
	КомплектующиеВСоставеОС.Параметры.УстановитьЗначениеПараметра("МоментАнализа", МоментАнализа);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗадатьПараметрыДляКомплектующихВСоставе("");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ТАБЛИЧНЫМ ПОЛЕМ ОСНОВНЫЕСРЕДСТВА

&НаКлиенте
Процедура ОсновныеСредстваПриАктивизацииСтроки(Элемент)
	
	ИмяТабличнойЧасти = "ОсновныеСредства";
	РаботаСТабличнымиЧастямиКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "Комплектующие");
	
	Если Элементы.ОсновныеСредства.ТекущиеДанные = Неопределено Тогда
		ЗадатьПараметрыДляКомплектующихВСоставе("");
	Иначе	
		ЗадатьПараметрыДляКомплектующихВСоставе(Элементы.ОсновныеСредства.ТекущиеДанные.ОсновноеСредство);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваПередУдалением(Элемент, Отказ)
	
	ИмяТабличнойЧасти = "ОсновныеСредства";
	РаботаСТабличнымиЧастямиКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "Комплектующие");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		Элемент.ТекущиеДанные.ОсновноеСредство = "";
	КонецЕсли;
	
	ИмяТабличнойЧасти = "ОсновныеСредства";
	Если НоваяСтрока Тогда

		РаботаСТабличнымиЧастямиКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтаФорма);
		РаботаСТабличнымиЧастямиКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "Комплектующие");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваОсновноеСредствоПриИзменении(Элемент)
	ЗадатьПараметрыДляКомплектующихВСоставе(Элементы.ОсновныеСредства.ТекущиеДанные.ОсновноеСредство);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ТАБЛИЧНЫМ ПОЛЕМ КОМПЛЕКТУЮЩИЕ

&НаКлиенте
Процедура КомплектующиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ИмяТабличнойЧасти = "ОсновныеСредства";
	Отказ = РаботаСТабличнымиЧастямиКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектующиеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИмяТабличнойЧасти = "ОсновныеСредства";
	Если НоваяСтрока Тогда
		РаботаСТабличнымиЧастямиКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры
