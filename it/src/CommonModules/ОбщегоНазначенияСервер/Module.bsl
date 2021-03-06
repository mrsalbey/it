
Функция ЕстьРеквизитДокумента(ИмяРеквизита, МетаданныеДокумента) Экспорт

	Если МетаданныеДокумента.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли; 

КонецФункции // ЕстьРеквизитДокумента()

Функция ПолучитьОписаниеТиповСтроки(ДлинаСтроки) Экспорт

	Возврат Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная));

КонецФункции // ПолучитьОписаниеТиповСтроки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ДВИЖЕНИЯМИ ДОКУМЕНТОВ

// Формирует структуру дерева значений, содержащего имена полей, которые
// нужно заполнить в запросе по шапке документа.
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Дерево значений.
//
Функция СформироватьДеревоПолейЗапросаПоШапке()  Экспорт

	ДеревоПолейЗапросаПоШапке = Новый ДеревоЗначений;

	ОписаниеТиповСтрока = ПолучитьОписаниеТиповСтроки(100);
	
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Объект"   , ОписаниеТиповСтрока);
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Поле"     , ОписаниеТиповСтрока);
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Псевдоним", ОписаниеТиповСтрока);
	
	Возврат ДеревоПолейЗапросаПоШапке;

КонецФункции // СформироватьДеревоПолейЗапросаПоШапке()

// Формирует запрос на дополнительные параметры, нужные при проведении документа.
//
// Параметры: 
//  ДокументОбъект                 - объект проводимого документа, 
//  ДеревоПолейЗапросаПоШапке      - дерево значений, содержащего имена полей, 
//                                   которые нужно заполнить в запросе по шапке документа.
//  СтруктураШапкиДокумента        - структура, содержащая значения реквизитов, относящихся к шапке документа,
//                                   необходимых для его проведения.
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
// Возвращаемое значение:
//  Дополненная по результату запроса структура СтруктураШапкиДокумента.
//
Функция СформироватьЗапросПоДеревуПолей(ДокументОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента)  Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ";

	СтрокиЗапроса           = "";
	ТаблицыЗапроса          = "";
	НуженКурсВалютыУпрУчета = Ложь;
	ЕстьУчетнаяПолитика     = Ложь;
	
	ДокументОбъектМетаданные = ДокументОбъект.Метаданные();
	
	
	// Реквизиты договора взаиморасчетов.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДоговорыКонтрагентов", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДоговорКонтрагента." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты договора взаиморасчетов регл.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДоговорыКонтрагентовРегл", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДоговорКонтрагентаРегл." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты организации.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Организации", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Организация." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты сделки.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Сделка", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		Если ЗначениеЗаполнено(ДокументОбъект.Сделка) Тогда
			СделкаМетаданные = ДокументОбъект.Сделка.Метаданные();
		Иначе
			СделкаМетаданные = Неопределено;
		КонецЕсли;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + ?(СделкаМетаданные = Неопределено ИЛИ СделкаМетаданные.Реквизиты.Найти(СокрЛП(СтрокаПоля.Поле)) = Неопределено,
								"NULL",
								"ВЫРАЗИТЬ(Док.Сделка КАК Документ." + СделкаМетаданные.Имя + ")." + СокрЛП(СтрокаПоля.Поле)) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты расчетного документа.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("РасчетныйДокумент", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		Если ЗначениеЗаполнено(ДокументОбъект.РасчетныйДокумент) Тогда
			СделкаМетаданные = ДокументОбъект.РасчетныйДокумент.Метаданные();
		Иначе
			СделкаМетаданные = Неопределено;
		КонецЕсли;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + ?(СделкаМетаданные = Неопределено, "NULL", "ВЫРАЗИТЬ(Док.РасчетныйДокумент КАК Документ." + СделкаМетаданные.Имя + ")." + СокрЛП(СтрокаПоля.Поле)) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Склад", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Склад." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	//++ Рогожин Сергей 14.05.2009
	
	// Реквизиты склада.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("бтк_СкладОтправитель", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл
			
			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.бтк_СкладОтправитель" +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));
			
		КонецЦикла;
		
	КонецЕсли;
	
	
	//-- Рогожин Сергей 14.05.2009
	
	// Реквизиты склада-группы.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладГруппа", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладГруппа." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладОтправитель", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладОтправитель." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументПеремещения", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументПеремещения." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументПередачи", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументПередачи." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-получателя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладПолучатель", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладПолучатель." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-ордера
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладОрдер", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладОрдер." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Заказ", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Заказ." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ВнутреннийЗаказ", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ВнутреннийЗаказ." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты заказа покупателя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ЗаказПокупателя", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ЗаказПокупателя." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты заказа поставщику
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ЗаказПоставщику", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ЗаказПоставщику." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;

	// Реквизиты номенклатуры
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Номенклатура", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Номенклатура." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;

	// Реквизиты документа основания
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументОснование", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументОснование." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Пустые реквизиты.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("NULL", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "NULL" +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Константы.
	ТаблицыЗапроса = ТаблицыЗапроса + ", Константы";

	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Константы", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			Если СтрокаПоля.Поле = "КурсВалютыУправленческогоУчета" Тогда

				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "КурсыВалютСрезПоследних.Курс КАК КурсВалютыУправленческогоУчета";
			
				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "КурсыВалютСрезПоследних.Кратность КАК КратностьВалютыУправленческогоУчета";
			
				НуженКурсВалютыУпрУчета = Истина;

			Иначе

				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "Константы." + СокрЛП(СтрокаПоля.Поле) +
				?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("УчетнаяПолитика", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда
		ЕстьУчетнаяПолитика = Истина;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл
			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС + 
			Символы.Таб + "УчетнаяПолитикаСрезПоследних." + СокрЛП(СтрокаПоля.Поле) +
				?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));
		КонецЦикла;
			
	КонецЕсли;

	// Надо добавить константу ВалютаРегламнтированногоУчета
	СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС + 
	Символы.Таб + "Константы.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета";

	СтрокаЗапросаКурсВалютыУпрУчета = Символы.ПС + "
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента,) КАК КурсыВалютСрезПоследних
	|	ПО Константы.ВалютаУправленческогоУчета = КурсыВалютСрезПоследних.Валюта";

	СтрокаРегистраУчетнойПолитики = Символы.ПС + "
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитика.СрезПоследних(&ДатаДокумента,) КАК УчетнаяПолитикаСрезПоследних
	|	ПО Истина";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ " + Сред(СтрокиЗапроса, 2) + "
	                | ИЗ 
	                |      Документ." + ДокументОбъектМетаданные.Имя + " КАК Док "+ ТаблицыЗапроса +
	                ?(НуженКурсВалютыУпрУчета, СтрокаЗапросаКурсВалютыУпрУчета,"") + Символы.ПС + 
	                ?(ЕстьУчетнаяПолитика, СтрокаРегистраУчетнойПолитики,"") + Символы.ПС + "
	                |     ГДЕ Док.Ссылка = &ДокументСсылка";

	// Установим параметры запроса.
	Запрос.УстановитьПараметр("ДокументСсылка" , ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента"  , ?(ЕстьРеквизитДокумента("ПериодРегистрации", ДокументОбъектМетаданные), КонецМесяца(ДокументОбъект.ПериодРегистрации), ДокументОбъект.Дата));

	ТаблицаЗапроса = Запрос .Выполнить().Выгрузить();

	Для Каждого Колонка из ТаблицаЗапроса.Колонки Цикл
		Если ТаблицаЗапроса.Количество() = 0 Тогда
			СтруктураШапкиДокумента.Вставить(Колонка.Имя, Неопределено);
		Иначе
			СтруктураШапкиДокумента.Вставить(Колонка.Имя, ТаблицаЗапроса[0][Колонка.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураШапкиДокумента;
	
КонецФункции // СформироватьЗапросПоДеревуПолей()

// Формирует структуру, содержащую значения реквизитов шапки документа.
//
// Параметры: 
//  ДокументОбъект - объект документа для формирования структуры шапки, 
//
// Возвращаемое значение:
//  Сформированная структура.
//
Функция СформироватьСтруктуруШапкиДокумента(ДокументОбъект) Экспорт

	СтруктураШапкиДокумента = Новый Структура;
	СтруктураШапкиДокумента.Вставить("Ссылка", ДокументОбъект.Ссылка);
	СтруктураШапкиДокумента.Вставить("Дата", ДокументОбъект.Дата);
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	Для каждого Реквизит из МетаданныеДокумента.Реквизиты Цикл
		СтруктураШапкиДокумента.Вставить(Реквизит.Имя, ДокументОбъект[Реквизит.Имя]);
	КонецЦикла;
	СтруктураШапкиДокумента.Вставить("ВидДокумента", МетаданныеДокумента.Имя);
	СтруктураШапкиДокумента.Вставить("ПредставлениеДокумента", СокрЛП(ДокументОбъект));

	Возврат СтруктураШапкиДокумента;

КонецФункции // СформироватьСтруктуруШапкиДокумента()

// По переданной структуре полей формирует запрос по табличной части документа.
//
// Параметры: 
//  ДокументОбъект        - объект проводимого документа, 
//  ИмяТабличнойЧасти     - строка, имя табличной части,
//  СтруктураПолей        - структура, ключ структуры содержит псевдоним поля запроса, значение - строку запроса,
//  СтруктураСложныхПолей - структура, ключ структуры содержит псевдоним поля запроса, значение - строку запроса,
//                          необязательный параметр, служит для передачи конструкций типа "ВЫБОР" и т.д.
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоТабличнойЧасти(ДокументОбъект, ИмяТабличнойЧасти, СтруктураПолей,
                                           СтруктураСложныхПолей = Неопределено) Экспорт

	ТекстЗапроса = "";
	
	ДокументМетаданные = ДокументОбъект.Метаданные();

	Для Каждого Реквизит Из СтруктураПолей Цикл

		ТекстЗапроса  = ТекстЗапроса + ",
		|Док." + Реквизит.Значение + 
		" КАК " + СокрЛП(Реквизит.Ключ);

	КонецЦикла;
	
	ТекстСоединение="";
	
	Запрос = Новый Запрос;

	Если ТипЗнч(СтруктураСложныхПолей) = Тип("Структура") Тогда // Добавим к запросу конструкции.
		
		Для Каждого Элемент Из СтруктураСложныхПолей Цикл
			
			ТекстЗапроса  = ТекстЗапроса + ",
			| " + Элемент.Значение + 
			" КАК " + СокрЛП(Элемент.Ключ);
			
		КонецЦикла;
	КонецЕсли;
		
	Запрос.Текст = "ВЫБРАТЬ 
				| Док.НомерСтроки " + ТекстЗапроса + "
				| ИЗ 
				|      Документ." + ДокументМетаданные.Имя + "."+ СокрЛП(ИмяТабличнойЧасти) + 
				" КАК Док"+ТекстСоединение+" 
				|     ГДЕ Док.Ссылка = &ДокументСсылка";


	// Установим параметры запроса.
	Запрос.УстановитьПараметр("ДокументСсылка" , ДокументОбъект.Ссылка);
	
	Если ДокументОбъект[ИмяТабличнойЧасти].Количество() = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ГДЕ Док.Ссылка = &ДокументСсылка", "ГДЕ ЛОЖЬ");
	КонецЕсли;

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоТабличнойЧасти()

// Формирует строку представления документа для сообщений при проведении.
//
// Параметры:
//  СтруктураШапкиДокумента - структура шапки документа.
//
// Возвращаемое значение
//  Строка с представлением документа.
//
Функция ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента) Экспорт

	Если СтруктураШапкиДокумента.Свойство("ВидОперации") Тогда
		ВидОперацииСтр = " (" + СтруктураШапкиДокумента.ВидОперации + ")";
	Иначе
		ВидОперацииСтр = "";
	КонецЕсли;

	Возврат "Проведение документа: " + СтруктураШапкиДокумента.ПредставлениеДокумента + ВидОперацииСтр;

КонецФункции // ПредставлениеДокументаПриПроведении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ ЦЕНАМИ ПО ПРОГРАММЕ

Функция ПолучитьЦеныПоОС_Программы(ТЗ_ОсновныхСредств, ДатаАнализа) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТЗ_ОсновныхСредств.ОсновноеСредство
	|ПОМЕСТИТЬ ТЗ_ОсновныхСредств
	|ИЗ
	|	&ТЗ_ОсновныхСредств КАК ТЗ_ОсновныхСредств");
	Запрос.УстановитьПараметр("ТЗ_ОсновныхСредств", ТЗ_ОсновныхСредств);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗ_ОсновныхСредств.ОсновноеСредство,
	               |	ОсновныеСредства.ИдентификаторПрограммы КАК Программа,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.Цена, 0) КАК Стоимость,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаСПоддержкой, 0) КАК СтоимостьСПоддержкой,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаПоддержки, 0) КАК СтоимостьПоддержки
	               |ИЗ
	               |	ТЗ_ОсновныхСредств КАК ТЗ_ОсновныхСредств
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОсновныеСредства КАК ОсновныеСредства
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныПрограмм.СрезПоследних(&ДатаАнализа, ) КАК ЦеныПрограммСрезПоследних
	               |			ПО ОсновныеСредства.ИдентификаторПрограммы = ЦеныПрограммСрезПоследних.Программа
	               |		ПО ТЗ_ОсновныхСредств.ОсновноеСредство = ОсновныеСредства.Ссылка";
	
	Запрос.УстановитьПараметр("ДатаАнализа", ДатаАнализа);
	
	ТЗ_ОС_Стоимость = Запрос.Выполнить().Выгрузить();
	
	Возврат(ТЗ_ОС_Стоимость);
	
КонецФункции // ()

Функция ЗаполнитьОсновныеСредстваСтоимостью(Объект, Ф_СтоимостьПрограмм = Ложь, Ф_СтоимостьПоддержки = Ложь) Экспорт

	ТЗ_Анализа = Объект.ОсновныеСредства.Выгрузить();
	ТЗ_Анализа.Свернуть("ОсновноеСредство");
	
	ТЗ_Стоимость = ПолучитьЦеныПоОС_Программы(ТЗ_Анализа, Объект.Дата);
	
	Для каждого Стр_Стоимость Из ТЗ_Стоимость Цикл
		
		Если ЗначениеЗаполнено(Стр_Стоимость.Стоимость) Тогда
		
			Стр_Отбора = Новый Структура;
			Стр_Отбора.Вставить("ОсновноеСредство", Стр_Стоимость.ОсновноеСредство);
			Масс_ОС = Объект.ОсновныеСредства.НайтиСтроки(Стр_Отбора);
			
			Для каждого Стр_ОС Из Масс_ОС Цикл
				Если НЕ ЗначениеЗаполнено(Стр_ОС.Стоимость) Тогда
					
					Если Ф_СтоимостьПрограмм Тогда
						Если ЗначениеЗаполнено(Стр_ОС.ДатаНачалаПоддержки) Тогда
							Стр_ОС.Стоимость 			= Стр_Стоимость.СтоимостьСПоддержкой;		
							Стр_ОС.СтоимостьПоддержки 	= Стр_Стоимость.СтоимостьСПоддержкой - Стр_Стоимость.Стоимость;		
						Иначе	
							Стр_ОС.Стоимость 			= Стр_Стоимость.Стоимость;		
						КонецЕсли; 
					ИначеЕсли Ф_СтоимостьПоддержки Тогда
						Стр_ОС.Стоимость 				= Стр_Стоимость.СтоимостьПоддержки;		
					КонецЕсли; 
					
				КонецЕсли; 
			КонецЦикла; 
		
		КонецЕсли; 
	
	КонецЦикла; 

КонецФункции // ПредставлениеДокументаПриПроведении()

Функция ПолучитьЦеныПоПрограмме(ТЗ_Программ, ДатаАнализа) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТЗ_Программ.Программа
	|ПОМЕСТИТЬ ТЗ_ОсновныхСредств
	|ИЗ
	|	&ТЗ_Программ КАК ТЗ_Программ");
	Запрос.УстановитьПараметр("ТЗ_Программ", ТЗ_Программ);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗ_Программ.Программа КАК Программа,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.Цена, 0) КАК Стоимость,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаСПоддержкой, 0) КАК СтоимостьСПоддержкой,
	               |	ЕСТЬNULL(ЦеныПрограммСрезПоследних.ЦенаПоддержки, 0) КАК СтоимостьПоддержки
	               |ИЗ
	               |	ТЗ_ОсновныхСредств КАК ТЗ_Программ
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныПрограмм.СрезПоследних(&ДатаАнализа, ) КАК ЦеныПрограммСрезПоследних
	               |		ПО ТЗ_Программ.Программа = ЦеныПрограммСрезПоследних.Программа";
	
	Запрос.УстановитьПараметр("ДатаАнализа", ДатаАнализа);
	
	ТЗ_Программ_Стоимость = Запрос.Выполнить().Выгрузить();
	
	Возврат(ТЗ_Программ_Стоимость);
	
КонецФункции // ()

Функция ЗаполнитьСтоимостьюПоПрограммам(Объект, ИмяТЧАнализа, Ф_СтоимостьПрограмм = Ложь, Ф_СтоимостьПоддержки = Ложь) Экспорт
	
	ТЗ_Анализа = Объект[ИмяТЧАнализа].Выгрузить();
	ТЗ_Анализа.Свернуть("Программа");
	
	ТЗ_Стоимость = ПолучитьЦеныПоПрограмме(ТЗ_Анализа, Объект.Дата);
	
	Для каждого Стр_Стоимость Из ТЗ_Стоимость Цикл
		
		Если ЗначениеЗаполнено(Стр_Стоимость.Стоимость) Тогда
		
			Стр_Отбора = Новый Структура;
			Стр_Отбора.Вставить("Программа", Стр_Стоимость.Программа);
			Масс_ОС = Объект[ИмяТЧАнализа].НайтиСтроки(Стр_Отбора);
			
			Для каждого Стр_ОС Из Масс_ОС Цикл
				Если НЕ ЗначениеЗаполнено(Стр_ОС.Стоимость) Тогда
					
					Если Ф_СтоимостьПрограмм Тогда
						Стр_ОС.Стоимость 			= Стр_Стоимость.Стоимость;		
					ИначеЕсли Ф_СтоимостьПоддержки Тогда
						Стр_ОС.Стоимость 			= Стр_Стоимость.СтоимостьПоддержки;		
					КонецЕсли; 
					
				КонецЕсли; 
			КонецЦикла; 
		
		КонецЕсли; 
	
	КонецЦикла; 

КонецФункции // ПредставлениеДокументаПриПроведении()


///////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ С ОТЧЕТАМИ

// Функция возвращает пользовательские настройки.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Пользовательские настроки отчета 
//
Функция ПолучитьПользовательскиеНастройки(ИмяОтчета, СтруктураПараметров, КлючВарианта = "Основной") Экспорт

    СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
    КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	НайденныйВариант = СхемаКомпоновкиДанных.ВариантыНастроек.Найти(КлючВарианта);
	Если НайденныйВариант = Неопределено Тогда
    	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Иначе	
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НайденныйВариант.Настройки);
	КонецЕсли;
	
    Для каждого КлючИЗначение Из СтруктураПараметров Цикл
        ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение,,, Истина);
    КонецЦикла;

    Возврат КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки;

КонецФункции // ПолучитьПользовательскиеНастройки()

