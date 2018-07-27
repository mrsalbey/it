
&НаСервере
Процедура ЗаполнитьДаннымиПоЦенам()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛОЖЬ КАК Пометка,
	               |	ИдентификаторыПрограмм.Ссылка КАК Программа,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.Цена, 0) КАК Цена,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаСПоддержкой, 0) КАК ЦенаСПоддержкой,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаПоддержки, 0) КАК ЦенаПоддержки
	               |ИЗ
	               |	РегистрСведений.ЦеныПрограмм.СрезПоследних(&ДатаАнализа, ) КАК ЦеныПрограммСрезПоследних
	               |		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыПрограмм КАК ИдентификаторыПрограмм
	               |		ПО ЦеныПрограммСрезПоследних.Программа = ИдентификаторыПрограмм.Ссылка";
	Запрос.УстановитьПараметр("ДатаАнализа",Объект.ДатаУстановки);
	
	ДеревоЦенПоПрограммамЗначение = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЗначениеВРеквизитФормы(ДеревоЦенПоПрограммамЗначение, "ДеревоЦенПоПрограммам");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ДатаУстановки = ТекущаяДата();	
	ЗаполнитьДаннымиПоЦенам();
	ВремДатаУстановки = Объект.ДатаУстановки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаУстановкиПриИзменении(Элемент)
	
	Если Вопрос("Изменилась дата установки цен. Список по ценам будет переформирован, продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
		ЗаполнитьДаннымиПоЦенам();	
		ВремДатаУстановки = Объект.ДатаУстановки;
	Иначе
		Объект.ДатаУстановки = ВремДатаУстановки;	
	КонецЕсли; 	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЦеныНаСервере()
	
	ДеревоЦенПоПрограммамЗначение = ДанныеФормыВЗначение(ДеревоЦенПоПрограммам, Тип("ДеревоЗначений"));
	Для каждого Строка_Цены Из ДеревоЦенПоПрограммамЗначение.Строки Цикл
		
		РС_Цен = РегистрыСведений.ЦеныПрограмм.СоздатьНаборЗаписей();
		
		Если Строка_Цены.Пометка Тогда
		
			РС_Цен.Отбор.Период.Установить(Объект.ДатаУстановки);
			РС_Цен.Отбор.Программа.Установить(Строка_Цены.Программа);
			РС_Цен.Прочитать();
			
			Если РС_Цен.Количество() = 0 Тогда
				РС_Записи_Цен = РС_Цен.Добавить();	
			Иначе
				РС_Записи_Цен = РС_Цен[0];	
			КонецЕсли; 
			
			РС_Записи_Цен.Период 				= Объект.ДатаУстановки;
			РС_Записи_Цен.Программа 			= Строка_Цены.Программа;
			РС_Записи_Цен.Цена 					= Строка_Цены.Цена;
			РС_Записи_Цен.ЦенаСПоддержкой 		= Строка_Цены.ЦенаСПоддержкой;
			РС_Записи_Цен.ЦенаПоддержки 		= Строка_Цены.ЦенаПоддержки;
			
			РС_Цен.Записать();
		
		КонецЕсли; 
		
	
	КонецЦикла; 
		
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦены(Команда)
	УстановитьЦеныНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЦенПоПрограммамЦенаПриИзменении(Элемент)
	Элементы.ДеревоЦенПоПрограммам.ТекущиеДанные.Пометка = Истина;	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЦенПоПрограммамЦенаСПоддержкойПриИзменении(Элемент)
	Элементы.ДеревоЦенПоПрограммам.ТекущиеДанные.Пометка = Истина;	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЦенПоПрограммамЦенаПоддержкиПриИзменении(Элемент)
	Элементы.ДеревоЦенПоПрограммам.ТекущиеДанные.Пометка = Истина;	
КонецПроцедуры
