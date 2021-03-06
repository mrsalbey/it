//////////////////////////////////////////////////////////////////////////////// 
// Переменные
// 

&НаКлиенте
Перем АдресЛицензийВХранилище;

&НаСервере
Функция ВернутьПустуюСсылкуПоТипу(СправочникСсылка)

	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ТипОбъекта = СправочникСсылка.Метаданные().Имя;
		Возврат	Справочники[ТипОбъекта].ПустаяСсылка();
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции //ВернутьПустуюСсылку	

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Элементы.ТаблицаОстатков.ТекущаяСтрока <> Неопределено Тогда
	
		СтрокаКоллекции = Объект.ТаблицаОстатков.НайтиПоИдентификатору(Элементы.ТаблицаОстатков.ТекущаяСтрока);
		СохраняемоеЗначение = СтрокаКоллекции.Идентификатор;
	
	КонецЕсли; 
	
	ЗаполнитьОстаткиНаСервере();
	
	ОбновитьТаблицы();
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Идентификатор", СохраняемоеЗначение);
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	
	НайденныеСтроки = Объект.ТаблицаОстатков.НайтиСтроки(ПараметрыОтбора);	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Элементы.ТаблицаОстатков.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиНаСервере() Экспорт
	
	Элементы.ТаблицаОстатков.ОтборСтрок = Новый ФиксированнаяСтруктура("Организация", Объект.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыНаСервере(Идентификатор) Экспорт
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ЗаполнитьТаблицы(Идентификатор);
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
КонецПроцедуры //ЗаполнитьТаблицыНаСервере	

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Элементы.ТаблицаОстатков.ТекущаяСтрока <> Неопределено Тогда
		СтрокаКоллекции = Объект.ТаблицаОстатков.НайтиПоИдентификатору(Элементы.ТаблицаОстатков.ТекущаяСтрока);
		СохраняемоеЗначение = СтрокаКоллекции.Идентификатор;
	КонецЕсли;
	
	ЗаполнитьОстатки();
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Идентификатор", СохраняемоеЗначение);
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	НайденныеСтроки = Объект.ТаблицаОстатков.НайтиСтроки(ПараметрыОтбора);	
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Элементы.ТаблицаОстатков.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ЗагрузитьНастройки();
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Организации.Код";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 0 Тогда
			Выборка.Следующий();
			Объект.Организация	= Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьОстатки();
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьОстатки()
	
	//Заполнение таблицы остатков
	Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	РазмещениеОбъектов.Организация,
	//			   |	РазмещениеОбъектов.ИдентификаторПрограммы КАК Идентификатор,
	//			   |	ЕСТЬNULL(ЗакупкиОбороты.КоличествоОборот, 0) КАК Закуплено,
	//			   |	ЕСТЬNULL(РазмещениеЛицензийОстатки.КоличествоОстаток, 0) КАК Размещено,
	//			   |	РазмещениеОбъектов.Установлено,
	//			   |	ЕСТЬNULL(ЛицензииОрганизацииОстатки.КоличествоОстаток, 0) КАК Свободно
	//			   |ИЗ
	//			   |	(ВЫБРАТЬ
	//			   |		ВложенныйЗапрос.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	//			   |		ЕСТЬNULL(МестонахождениеОССрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
	//			   |		СУММА(ВложенныйЗапрос.Установлено) КАК Установлено
	//			   |	ИЗ
	//			   |		(ВЫБРАТЬ
	//			   |			РазмещениеОбъектовОстатки.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	//			   |			РазмещениеОбъектовОстатки.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	//			   |			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК Установлено
	//			   |		ИЗ
	//			   |			РегистрНакопления.РазмещениеОбъектов.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК РазмещениеОбъектовОстатки
	//			   |		
	//			   |		СГРУППИРОВАТЬ ПО
	//			   |			РазмещениеОбъектовОстатки.ИдентификаторПрограммы,
	//			   |			РазмещениеОбъектовОстатки.ИдентификаторКомпьютера) КАК ВложенныйЗапрос
	//			   |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОССрезПоследних
	//			   |			ПО ВложенныйЗапрос.ИдентификаторКомпьютера = МестонахождениеОССрезПоследних.ОсновноеСредство
	//			   |	
	//			   |	СГРУППИРОВАТЬ ПО
	//			   |		ВложенныйЗапрос.ИдентификаторПрограммы,
	//			   |		ЕСТЬNULL(МестонахождениеОССрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))) КАК РазмещениеОбъектов
	//			   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Закупки.Обороты(, , , ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЗакупкиОбороты
	//			   |		ПО РазмещениеОбъектов.ИдентификаторПрограммы = ЗакупкиОбороты.ИдентификаторПрограммы
	//			   |			И РазмещениеОбъектов.Организация = ЗакупкиОбороты.Организация
	//			   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещениеЛицензий.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК РазмещениеЛицензийОстатки
	//			   |		ПО РазмещениеОбъектов.ИдентификаторПрограммы = РазмещениеЛицензийОстатки.ИдентификаторПрограммы
	//			   |			И РазмещениеОбъектов.Организация = РазмещениеЛицензийОстатки.Организация
	//			   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЛицензииОрганизации.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЛицензииОрганизацииОстатки
	//			   |		ПО РазмещениеОбъектов.ИдентификаторПрограммы = ЛицензииОрганизацииОстатки.ИдентификаторПрограммы
	//			   |			И РазмещениеОбъектов.Организация = ЛицензииОрганизацииОстатки.Организация
	//			   |
	//			   |УПОРЯДОЧИТЬ ПО
	//			   |	Идентификатор";
	
	////Запрос.Текст = "ВЫБРАТЬ
	////			   |	ВложенныйЗапрос.Организация КАК Организация,
	////			   |	ВложенныйЗапрос.ИдентификаторПрограммы КАК Идентификатор,
	////			   |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Закуплено, 0)) КАК Закуплено,
	////			   |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Размещено, 0)) КАК Размещено,
	////			   |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Установлено, 0)) КАК Установлено,
	////			   |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Свободно, 0)) КАК Свободно
	////			   |ИЗ
	////			   |	(ВЫБРАТЬ
	////			   |		ВложенныйЗапрос.Организация КАК Организация,
	////			   |		ВложенныйЗапрос.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	////			   |		ВложенныйЗапрос.Установлено КАК Установлено,
	////			   |		NULL КАК Закуплено,
	////			   |		NULL КАК Размещено,
	////			   |		NULL КАК Свободно
	////			   |	ИЗ
	////			   |		(ВЫБРАТЬ
	////			   |			ВложенныйЗапрос.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	////			   |			СУММА(ВложенныйЗапрос.Установлено) КАК Установлено,
	////			   |			ВложенныйЗапрос.Организация КАК Организация
	////			   |		ИЗ
	////			   |			(ВЫБРАТЬ
	////			   |				ВложенныйЗапрос.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	////			   |				ВложенныйЗапрос.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	////			   |				ВложенныйЗапрос.Установлено КАК Установлено,
	////			   |				ЕСТЬNULL(МестонахождениеОССрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
	////			   |			ИЗ
	////			   |				(ВЫБРАТЬ
	////			   |					РазмещениеОбъектовОстатки.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	////			   |					РазмещениеОбъектовОстатки.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	////			   |					КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК Установлено
	////			   |				ИЗ
	////			   |					РегистрНакопления.РазмещениеОбъектов.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК РазмещениеОбъектовОстатки
	////			   |				
	////			   |				СГРУППИРОВАТЬ ПО
	////			   |					РазмещениеОбъектовОстатки.ИдентификаторКомпьютера,
	////			   |					РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК ВложенныйЗапрос
	////			   |					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОССрезПоследних
	////			   |					ПО ВложенныйЗапрос.ИдентификаторКомпьютера = МестонахождениеОССрезПоследних.ОсновноеСредство
	////			   |			
	////			   |			СГРУППИРОВАТЬ ПО
	////			   |				ВложенныйЗапрос.ИдентификаторКомпьютера,
	////			   |				ВложенныйЗапрос.ИдентификаторПрограммы,
	////			   |				ВложенныйЗапрос.Установлено,
	////			   |				ЕСТЬNULL(МестонахождениеОССрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))) КАК ВложенныйЗапрос
	////			   |		
	////			   |		СГРУППИРОВАТЬ ПО
	////			   |			ВложенныйЗапрос.Организация,
	////			   |			ВложенныйЗапрос.ИдентификаторПрограммы) КАК ВложенныйЗапрос
	////			   |	
	////			   |	ОБЪЕДИНИТЬ ВСЕ
	////			   |	
	////			   |	ВЫБРАТЬ
	////			   |		ЗакупкиОбороты.Организация,
	////			   |		ЗакупкиОбороты.ИдентификаторПрограммы,
	////			   |		NULL,
	////			   |		ЗакупкиОбороты.КоличествоОборот,
	////			   |		NULL,
	////			   |		NULL
	////			   |	ИЗ
	////			   |		РегистрНакопления.Закупки.Обороты(, , , ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЗакупкиОбороты
	////			   |	
	////			   |	ОБЪЕДИНИТЬ ВСЕ
	////			   |	
	////			   |	ВЫБРАТЬ
	////			   |		РазмещениеЛицензийОстатки.Организация,
	////			   |		РазмещениеЛицензийОстатки.ИдентификаторПрограммы,
	////			   |		NULL,
	////			   |		NULL,
	////			   |		РазмещениеЛицензийОстатки.КоличествоОстаток,
	////			   |		NULL
	////			   |	ИЗ
	////			   |		РегистрНакопления.РазмещениеЛицензий.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК РазмещениеЛицензийОстатки
	////			   |	
	////			   |	ОБЪЕДИНИТЬ ВСЕ
	////			   |	
	////			   |	ВЫБРАТЬ
	////			   |		ЛицензииОрганизацииОстатки.Организация,
	////			   |		ЛицензииОрганизацииОстатки.ИдентификаторПрограммы,
	////			   |		NULL,
	////			   |		NULL,
	////			   |		NULL,
	////			   |		ЛицензииОрганизацииОстатки.КоличествоОстаток
	////			   |	ИЗ
	////			   |		РегистрНакопления.ЛицензииОрганизации.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЛицензииОрганизацииОстатки) КАК ВложенныйЗапрос
	////			   |
	////			   |СГРУППИРОВАТЬ ПО
	////			   |	ВложенныйЗапрос.Организация,
	////			   |	ВложенныйЗапрос.ИдентификаторПрограммы
	////			   |
	////			   |УПОРЯДОЧИТЬ ПО
	////			   |	Идентификатор";
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Организация КАК Организация,
	               |	ВложенныйЗапрос.ИдентификаторПрограммы КАК Идентификатор,
	               |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Закуплено, 0)) КАК Закуплено,
	               |	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Свободно, 0)) КАК Свободно,
	               |	ВложенныйЗапрос.ИдентификаторПрограммы.ВариантРазмещения КАК ВариантРазмещения
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЗакупкиОбороты.Организация КАК Организация,
	               |		ЗакупкиОбороты.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	               |		ЗакупкиОбороты.КоличествоОборот КАК Закуплено,
	               |		NULL КАК Свободно
	               |	ИЗ
	               |		РегистрНакопления.Закупки.Обороты(, , , ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЗакупкиОбороты
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ЛицензииОрганизацииОстатки.Организация,
	               |		ЛицензииОрганизацииОстатки.ИдентификаторПрограммы,
	               |		NULL,
	               |		ЛицензииОрганизацииОстатки.КоличествоОстаток
	               |	ИЗ
	               |		РегистрНакопления.ЛицензииОрганизации.Остатки(, ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)) КАК ЛицензииОрганизацииОстатки) КАК ВложенныйЗапрос
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.ИдентификаторПрограммы
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Идентификатор";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Объект.ТаблицаОстатков.Загрузить(Результат);
	
КонецФункции //ЗаполнитьОстатки

&НаСервере
Процедура ЗаполнитьРазмещениеНаСервере(СтруктураОтбора)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РазмещениеЛицензийОстатки.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	               |	РазмещениеЛицензийОстатки.ПодразделениеОрганизации КАК Подразделение,
	               |	МестонахождениеОССрезПоследних.МОЛ КАК Пользователь,
	               |	РазмещениеЛицензийОстатки.ИдентификаторУстановлено КАК Идентификатор,
	               |	РазмещениеЛицензийОстатки.Лицензия,
	               |	РазмещениеЛицензийОстатки.КоличествоОстаток КАК Количество,
	               |	РазмещениеЛицензийОстатки.Организация,
	               |	ЛОЖЬ КАК Флаг
	               |ИЗ
	               |	РегистрНакопления.РазмещениеЛицензий.Остатки(
	               |			,
	               |			Организация = &Организация
	               |				И ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)
	               |				И ИдентификаторПрограммы = &Лицензия) КАК РазмещениеЛицензийОстатки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(, Организация = &Организация) КАК МестонахождениеОССрезПоследних
	               |		ПО РазмещениеЛицензийОстатки.ИдентификаторКомпьютера = МестонахождениеОССрезПоследних.ОсновноеСредство";
				   
	Запрос.УстановитьПараметр("Организация", СтруктураОтбора.Организация);
	Запрос.УстановитьПараметр("Лицензия", СтруктураОтбора.Лицензия);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Объект.ТаблицаРазмещено.Загрузить(Результат);
	
	//Установим значение Установлено строки ТаблицыОстатков с учетом аналогов
	//Объект.ТаблицаОстатков[Элементы.ТаблицаОстатков.ТекущаяСтрока].Установлено = Результат.Итог("Количество");
	
	////Объект.ТаблицаОстатков[Элементы.ТаблицаОстатков.ТекущаяСтрока].Размещено = Результат.Итог("Количество");
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьУстановленоНаСервере(СтруктураОтбора)
	
	Если СтруктураОтбора.Лицензия <> Неопределено Тогда
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", СтруктураОтбора.Организация);
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	РазмещениеОбъектов.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	//			   |	СУММА(РазмещениеОбъектов.Количество) КАК Количество,
	//			   |	МестонахождениеОССрезПоследних.МОЛ КАК Пользователь,
	//			   |	&Организация,
	//			   |	&Лицензия КАК Идентификатор,
	//			   |	МестонахождениеОССрезПоследних.ПодразделениеОрганизации КАК Подразделение,
	//			   |	ИСТИНА КАК Флаг
	//			   |ИЗ
	//			   |	(ВЫБРАТЬ
	//			   |		РазмещениеОбъектовОстатки.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
	//			   |		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК Количество,
	//			   |		РазмещениеОбъектовОстатки.ПодразделениеОрганизации КАК ПодразделениеОрганизации
	//			   |	ИЗ
	//			   |		РегистрНакопления.РазмещениеОбъектов.Остатки(
	//			   |				,
	//			   |				Организация = &Организация
	//			   |					И ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)
	//			   |					И ИдентификаторПрограммы = &Лицензия
	//			   |					И НЕ ИдентификаторКомпьютера В
	//			   |							(ВЫБРАТЬ РАЗЛИЧНЫЕ
	//			   |								РазмещениеЛицензийОстатки.ИдентификаторКомпьютера
	//			   |							ИЗ
	//			   |								РегистрНакопления.РазмещениеЛицензий.Остатки(, Организация = &Организация
	//			   |									И ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)
	//			   |									И ИдентификаторПрограммы = &Лицензия) КАК РазмещениеЛицензийОстатки)) КАК РазмещениеОбъектовОстатки
	//			   |	
	//			   |	СГРУППИРОВАТЬ ПО
	//			   |		РазмещениеОбъектовОстатки.ИдентификаторКомпьютера,
	//			   |		РазмещениеОбъектовОстатки.ПодразделениеОрганизации) КАК РазмещениеОбъектов
	//			   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(, Организация = &Организация) КАК МестонахождениеОССрезПоследних
	//			   |		ПО РазмещениеОбъектов.ИдентификаторКомпьютера = МестонахождениеОССрезПоследних.ОсновноеСредство
	//			   |
	//			   |СГРУППИРОВАТЬ ПО
	//			   |	РазмещениеОбъектов.ИдентификаторКомпьютера,
	//			   |	РазмещениеОбъектов.ПодразделениеОрганизации,
	//			   |	МестонахождениеОССрезПоследних.МОЛ,
	//			   |	МестонахождениеОССрезПоследних.ПодразделениеОрганизации";
	//
	//Запрос.УстановитьПараметр("Организация", СтруктураОтбора.Организация);
	//Запрос.УстановитьПараметр("Лицензия", СтруктураОтбора.Лицензия);
	
		Если СтруктураОтбора.Лицензия.ВариантРазмещения = Перечисления.ВариантыРазмещенияЛицензий.НаОрганизацию Тогда
			
			Запрос.Текст = "ВЫБРАТЬ
			               |	РазмещениеЛицензийОстатки.Организация,
			               |	РазмещениеЛицензийОстатки.ИдентификаторУстановлено,
			               |	РазмещениеЛицензийОстатки.ИдентификаторКомпьютера
			               |ПОМЕСТИТЬ втРазмещеноКомпьютеры
			               |ИЗ
			               |	РегистрНакопления.РазмещениеЛицензий.Остатки(
			               |			,
			               |			Организация = &Организация
			               |				И ИдентификаторУстановлено = &ИдентификаторПрограммы) КАК РазмещениеЛицензийОстатки
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ
			               |	ВложенныйЗапрос.Организация,
			               |	ВложенныйЗапрос.Подразделение,
			               |	ВложенныйЗапрос.ИдентификаторКомпьютера,
			               |	ВложенныйЗапрос.Идентификатор,
			               |	ВложенныйЗапрос.Пользователь,
			               |	ВложенныйЗапрос.Количество,
			               |	ИСТИНА КАК Флаг,
			               |	ЕСТЬNULL(ОтключенныеКомпьютерыСрезПоследних.Отключен, ЛОЖЬ) КАК Отключен
			               |ИЗ
			               |	(ВЫБРАТЬ
			               |		КомпьютерыОрганизации.Организация КАК Организация,
			               |		КомпьютерыОрганизации.ПодразделениеОрганизации КАК Подразделение,
			               |		КомпьютерыОрганизации.ОсновноеСредство КАК ИдентификаторКомпьютера,
			               |		КомпьютерыОрганизации.МОЛ КАК Пользователь,
			               |		ОбязательныйСофтОрганизаций.ИдентификаторПрограммы КАК Идентификатор,
			               |		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбязательныйСофтОрганизаций.ИдентификаторПрограммы) КАК Количество
			               |	ИЗ
			               |		РегистрСведений.ОбязательныйСофтОрганизаций КАК ОбязательныйСофтОрганизаций
			               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(, ) КАК КомпьютерыОрганизации
			               |			ПО ОбязательныйСофтОрганизаций.Организация = КомпьютерыОрганизации.Организация
			               |	ГДЕ
			               |		ОбязательныйСофтОрганизаций.Организация = &Организация
			               |		И ОбязательныйСофтОрганизаций.ИдентификаторПрограммы = &ИдентификаторПрограммы
			               |	
			               |	СГРУППИРОВАТЬ ПО
			               |		КомпьютерыОрганизации.Организация,
			               |		КомпьютерыОрганизации.ПодразделениеОрганизации,
			               |		КомпьютерыОрганизации.ОсновноеСредство,
			               |		КомпьютерыОрганизации.МОЛ,
			               |		ОбязательныйСофтОрганизаций.ИдентификаторПрограммы) КАК ВложенныйЗапрос
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтключенныеКомпьютеры.СрезПоследних КАК ОтключенныеКомпьютерыСрезПоследних
			               |		ПО ВложенныйЗапрос.ИдентификаторКомпьютера = ОтключенныеКомпьютерыСрезПоследних.ИдентификаторКомпьютера
			               |ГДЕ
			               |	НЕ ЕСТЬNULL(ОтключенныеКомпьютерыСрезПоследних.Отключен, ЛОЖЬ)
			               |	И НЕ (ВложенныйЗапрос.Организация, ВложенныйЗапрос.Идентификатор, ВложенныйЗапрос.ИдентификаторКомпьютера) В
			               |				(ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |					втРазмещеноКомпьютеры.Организация,
			               |					втРазмещеноКомпьютеры.ИдентификаторУстановлено,
			               |					втРазмещеноКомпьютеры.ИдентификаторКомпьютера
			               |				ИЗ
			               |					втРазмещеноКомпьютеры КАК втРазмещеноКомпьютеры)";
						   
			Запрос.УстановитьПараметр("ИдентификаторПрограммы", СтруктураОтбора.Лицензия);	
						   
		Иначе				   
		
			Запрос.Текст = "ВЫБРАТЬ
			               |	МестонахождениеОССрезПоследних.Организация,
			               |	МестонахождениеОССрезПоследних.ПодразделениеОрганизации КАК Подразделение,
			               |	УстановленоОстатки.ИдентификаторКомпьютера,
			               |	УстановленоОстатки.ИдентификаторПрограммы КАК Идентификатор,
			               |	МестонахождениеОССрезПоследних.МОЛ КАК Пользователь,
			               |	УстановленоОстатки.Количество,
			               |	ИСТИНА КАК Флаг,
			               |	ЕСТЬNULL(ОтключенныеКомпьютерыСрезПоследних.Отключен, ЛОЖЬ) КАК Отключен
			               |ИЗ
			               |	(ВЫБРАТЬ
			               |		РазмещениеОбъектовОстатки.ИдентификаторКомпьютера КАК ИдентификаторКомпьютера,
			               |		РазмещениеОбъектовОстатки.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
			               |		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК Количество
			               |	ИЗ
			               |		РегистрНакопления.РазмещениеОбъектов.Остатки(
			               |				,
			               |				ИдентификаторПрограммы В (&СписокИдентификаторов)
			               |					И ИдентификаторПрограммы.ПризнакУчета = ЗНАЧЕНИЕ(Перечисление.ПризнакУчетаПрограмм.Учитывать)
			               |					И НЕ ИдентификаторКомпьютера В
			               |							(ВЫБРАТЬ
			               |								РазмещениеЛицензийОстатки.ИдентификаторКомпьютера
			               |							ИЗ
			               |								РегистрНакопления.РазмещениеЛицензий.Остатки(, Организация = &Организация
			               |									И ИдентификаторУстановлено В (&СписокИдентификаторов)) КАК РазмещениеЛицензийОстатки)) КАК РазмещениеОбъектовОстатки
			               |	
			               |	СГРУППИРОВАТЬ ПО
			               |		РазмещениеОбъектовОстатки.ИдентификаторКомпьютера,
			               |		РазмещениеОбъектовОстатки.ИдентификаторПрограммы) КАК УстановленоОстатки
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОССрезПоследних
			               |		ПО УстановленоОстатки.ИдентификаторКомпьютера = МестонахождениеОССрезПоследних.ОсновноеСредство
			               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтключенныеКомпьютеры.СрезПоследних КАК ОтключенныеКомпьютерыСрезПоследних
			               |		ПО УстановленоОстатки.ИдентификаторКомпьютера = ОтключенныеКомпьютерыСрезПоследних.ИдентификаторКомпьютера
			               |ГДЕ
			               |	МестонахождениеОССрезПоследних.Организация = &Организация";
						   
			Запрос.УстановитьПараметр("СписокИдентификаторов", УправлениеОсновнымиСредствамиСервер.ВернутьАналогиИдентификатораНаСервере(СтруктураОтбора.Лицензия));	
		
		КонецЕсли;

		Результат = Запрос.Выполнить().Выгрузить();
		
	Иначе
		
		Результат = Новый ТаблицаЗначений;
		
	КонецЕсли;	
	
	Объект.ТаблицаУстановлено.Загрузить(Результат);
	
КонецПроцедуры //ЗаполнитьУстановленоНаСервере	

&НаКлиенте
Процедура ОбновитьТаблицы()
	
	Если Элементы.ТаблицаОстатков.ТекущиеДанные <> Неопределено Тогда
		
		СтруктураОтбора = Новый ФиксированнаяСтруктура("Организация, Лицензия", Элементы.ТаблицаОстатков.ТекущиеДанные.Организация, Элементы.ТаблицаОстатков.ТекущиеДанные.Идентификатор);
		//ЗаполнитьРазмещениеНаСервере(СтруктураОтбора);
		//ЗаполнитьУстановленоНаСервере(СтруктураОтбора);
		
	Иначе
		
		СтруктураОтбора = Новый ФиксированнаяСтруктура("Организация, Лицензия", Неопределено, Неопределено);
		
	КонецЕсли;
	
	ЗаполнитьРазмещениеНаСервере(СтруктураОтбора);
	ЗаполнитьУстановленоНаСервере(СтруктураОтбора);
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаОстатковПриАктивизацииСтроки(Элемент)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Флаг", Истина);
	
	ИзмененныеСтроки = Объект.ТаблицаРазмещено.НайтиСтроки(ПараметрыОтбора);
	Если ИзмененныеСтроки.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Нет); 
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаписатьИзменения();	
		КонецЕсли;
		
	КонецЕсли;	
	
	ОбновитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьОстаткиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Функция СкопироватьЛицензию(Строка, Таблица, ВидДвижения)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторКомпьютера",	Строка.ИдентификаторКомпьютера); 
	ПараметрыОтбора.Вставить("Подразделение", 			Строка.Подразделение); 
	ПараметрыОтбора.Вставить("Пользователь", 			Строка.Пользователь); 
	
	НайденныеСтроки = Таблица.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() = 0 Тогда
		
		НайденнаяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НайденнаяСтрока, Строка,,);
		
		//НайденнаяСтрока.Идентификатор	= ИдентификаторПрограммы;
		//НайденнаяСтрока.Организация 	= Объект.Организация;
		
	Иначе
		
		НайденнаяСтрока = НайденныеСтроки[0];
		НайденнаяСтрока.Количество = НайденнаяСтрока.Количество + Строка.Количество;
		
	КонецЕсли;	
	
	Если ВидДвижения = "Приход" Тогда
		НайденнаяСтрока.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияНакопления.Приход");
	Иначе
		Строка.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияНакопления.Расход");
		Строка.Флаг	= Истина;
	КонецЕсли;	
	
	//Уменьшим свободный остаток на количество размещенных лицензий
	////ТекущиеДанныеОстатки	= Элементы.ТаблицаОстатков.ТекущиеДанные;
	////ТекущиеДанныеОстатки.Свободно = ТекущиеДанныеОстатки.Свободно - НайденнаяСтрока.Количество;
	////ТекущиеДанныеОстатки.Размещено	= ТекущиеДанныеОстатки.Размещено + НайденнаяСтрока.Количество;
	
КонецФункции //СкопироватьЛицензию	

&НаКлиенте
Процедура СкопироватьЛицензии(Массив, Таблица, ВидДвижения)
	
	Если ВидДвижения = "Приход" Тогда 
	
		ИдентификаторПрограммы	= Элементы.ТаблицаОстатков.ТекущиеДанные.Идентификатор;
		СвободныйОстаток 		= Элементы.ТаблицаОстатков.ТекущиеДанные.Свободно;
		
		НеобходимоРазместить = Массив.Количество();
		Если НеобходимоРазместить > СвободныйОстаток Тогда
			
			ТекстСообщения = НСтр("ru = 'Недостаточно лицензий %1 для размещения. Свободно: %2, необходимо; %3.'");
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИдентификаторПрограммы,
			СвободныйОстаток, НеобходимоРазместить);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение,,);
			//Возврат;
			
		КонецЕсли;
		
	КонецЕсли;	
		
	Для каждого Строка Из Массив Цикл
		
		НоваяСтрока = СкопироватьЛицензию(Строка, Таблица, ВидДвижения);
		
	КонецЦикла;	
	
КонецПроцедуры //СкопироватьЛицензии

&НаКлиенте
Процедура ТаблицаУстановленоОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда	
		
		СкопироватьЛицензии(ПараметрыПеретаскивания.Значение, Объект.ТаблицаРазмещено, "Приход");
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазмещеноЛицензияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные	= Элементы.ТаблицаОстатков.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", ТекущиеДанные.Организация);
		ПараметрыФормы.Вставить("ИдентификаторПрограммы", ТекущиеДанные.Идентификатор);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		ОткрытьФорму("Справочник.ОсновныеСредства.Форма.ФормаСпискаСОстатками", ПараметрыФормы, Элементы.ТаблицаРазмещено, УникальныйИдентификатор);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРазмещеноОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Элементы.ТаблицаРазмещено.ТекущиеДанные.Лицензия	= ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьРаспределениеНаСервере(СтруктураДокумента)
	
	ДокументОбъект = Документы.РаспределениеЛицензий.СоздатьДокумент();
	ДокументОбъект.Дата = СтруктураДокумента.Дата;
	
	ДокументОбъект.Заполнить(СтруктураДокумента);
	
	Для каждого ТабличнаяЧасть Из СтруктураДокумента.ТабличныеЧасти Цикл
		
		ДокументОбъект[ТабличнаяЧасть.Ключ].Загрузить(ТабличнаяЧасть.Значение);
		
	КонецЦикла;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат ДокументОбъект;
	
КонецФункции //СформироватьРаспределениеНаСервере	

&НаСервере
Процедура СформироватьРаспределенияНаСервере()
	
	СтруктураОтбора = Новый Структура("Флаг", Истина);
	ОсновныеСредства = Объект.ТаблицаРазмещено.Выгрузить(СтруктураОтбора); 	//скопировать
	
	//ОсновныеСредства.Колонки.Добавить("ВидДвижения");
	//ОсновныеСредства.ЗаполнитьЗначения(Перечисления.ВидДвиженияНакопления.Приход, "ВидДвижения");
	
	ОсновныеСредства.Колонки["Идентификатор"].Имя = "ИдентификаторУстановлено";
	ОсновныеСредства.Колонки["Подразделение"].Имя = "ПодразделениеОрганизации";
	
	СтруктураДокумента = Новый Структура;
	СтруктураДокумента.Вставить("Организация", Объект.Организация);
	СтруктураДокумента.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	СтруктураДокумента.Вставить("Дата", ТекущаяДата());
	
	СтруктураДокумента.Вставить("ТабличныеЧасти", Новый Структура("ОсновныеСредства", ОсновныеСредства));
	
	Если ОсновныеСредства.Количество() > 0 Тогда
		
		НовыйДокумент = СформироватьРаспределениеНаСервере(СтруктураДокумента);
		
	КонецЕсли;	

КонецПроцедуры //СформироватьРаспределенияНаСервере

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	Если Объект.ТаблицаРазмещено.Количество() > 0 Тогда
		
		//Необходимо вставить проверку на заполнение колонки лицензия
		Для каждого Строка Из Объект.ТаблицаРазмещено Цикл
			
			Если ЗначениеЗаполнено(Строка.ВидДвижения) И НЕ ЗначениеЗаполнено(Строка.Лицензия) Тогда
				
				ИндексСтрокиКоллекции = Объект.ТаблицаРазмещено.Индекс(Строка); 
				
				ТекстСообщения = НСтр("ru = 'Не выбрана лицензия.'");
				ИмяПоля = СтрЗаменить("Объект.ТаблицаРазмещено[x].Лицензия", "x", ИндексСтрокиКоллекции); 	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяПоля,);
				
				Возврат;
				
			ИначеЕсли ЗначениеЗаполнено(Строка.ВидДвижения) И Строка.Количество > 1 Тогда
			
				ИндексСтрокиКоллекции = Объект.ТаблицаРазмещено.Индекс(Строка); 
				
				ТекстСообщения = НСтр("ru = 'Неверное количество лицензий.'");
				ИмяПоля = СтрЗаменить("Объект.ТаблицаРазмещено[x].Количество", "x", ИндексСтрокиКоллекции); 	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяПоля,);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЦикла;	
		
		СформироватьРаспределенияНаСервере();
		
		ОбновитьТаблицы();	
		
	КонецЕсли;
	
КонецПроцедуры //ЗаписатьИзменения	

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьИзменения();	
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЛицензииИзХранилища(АдресЛицензийВХранилище)
	Объект.ТаблицаРазмещено.Загрузить(ПолучитьИзВременногоХранилища(АдресЛицензийВХранилище));
КонецПроцедуры	

&НаСервере
Функция ПоместитьРазмещеноВХранилище() 
	Возврат ПоместитьВоВременноеХранилище(Объект.ТаблицаРазмещено.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура Изменить(Команда)
	
	ТекущиеДанные	= Элементы.ТаблицаОстатков.ТекущиеДанные;
	
	АдресЛицензийВХранилище = ПоместитьРазмещеноВХранилище();
	ПараметрыПодбора = Новый Структура("АдресЛицензийДокумента, Организация, ИдентификаторПрограммы", АдресЛицензийВХранилище, ТекущиеДанные.Организация, ТекущиеДанные.Идентификатор);
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ФормаПодбора = ОткрытьФорму("Обработка.РаспределениеЛицензий.Форма.ФормаИзмененияТабличнойЧасти", ПараметрыПодбора, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПодбор() Экспорт
	ПолучитьЛицензииИзХранилища(АдресЛицензийВХранилище);  
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьЛицензию(Команда)
	
	Если Элементы.ТаблицаУстановлено.ТекущиеДанные <> Неопределено Тогда
		
		МассивСтроки = Новый Массив;
		МассивСтроки.Добавить(Элементы.ТаблицаУстановлено.ТекущиеДанные);
	
		СкопироватьЛицензии(МассивСтроки, Объект.ТаблицаРазмещено, "Приход");
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьЛицензию(Команда)
	
	Если Элементы.ТаблицаРазмещено.ТекущиеДанные <> Неопределено Тогда
		
		ВидДвижения = Элементы.ТаблицаРазмещено.ТекущиеДанные.ВидДвижения;
		Если НЕ ЗначениеЗаполнено(ВидДвижения) Тогда
		
			МассивСтроки = Новый Массив;
			МассивСтроки.Добавить(Элементы.ТаблицаРазмещено.ТекущиеДанные);
		
			СкопироватьЛицензии(МассивСтроки, Объект.ТаблицаУстановлено, "Расход");
			
		ИначеЕсли ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияНакопления.Приход") Тогда
			
			//Объект.ТаблицаРазмещено.Удалить(Элементы.ТаблицаРазмещено.ТекущаяСтрока); 	
			Объект.ТаблицаРазмещено.Удалить(Элементы.ТаблицаРазмещено.ТекущиеДанные); 	
			
		ИначеЕсли ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияНакопления.Расход") Тогда
			
			ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияНакопления.ПустаяСсылка");
			
		КонецЕсли;	
	
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаРазмещеноОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда	
		
		СкопироватьЛицензии(ПараметрыПеретаскивания.Значение, Объект.ТаблицаУстановлено, "Расход");
		
	КонецЕсли;	

КонецПроцедуры


&НаСервере
Процедура ЗагрузитьНастройки()

	ИдентификаторПользователя = Пользователи.ТекущийПользователь().УникальныйИдентификатор();
	ЗначениеНастроек = ХранилищаНастроек.НастройкиФорм.Загрузить("Обработка.РаспределениеЛицензий");
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда
		 Объект.Организация = ЗначениеНастроек.Получить("Организация");
	КонецЕсли;

КонецПроцедуры 


&НаСервере
Функция СохранитьНастройки()

	Настройки = Новый Соответствие;
	Настройки.Вставить("Организация",	Объект.Организация);
	
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().УникальныйИдентификатор();
	КлючНастроек = "НастройкиРабочегоСтола_" + ИдентификаторПользователя;

	ХранилищаНастроек.НастройкиФорм.Сохранить("Обработка.РаспределениеЛицензий", КлючНастроек, Настройки);

КонецФункции

&НаКлиенте
Процедура ПриЗакрытии()
	
	//СохранитьНастройки();
	
КонецПроцедуры //ПриЗакрытии

