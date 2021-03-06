
// Получить таблицу .
//
Функция ПолучитьТаблицуПервоначальныеСведенияОС(СтруктураШапкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка КАК Регистратор,
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка.Дата КАК Период,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ОсновноеСредство,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ПервоначальнаяСтоимость КАК Стоимость
	               |ИЗ
	               |	Документ.ВводНачальныхОстатковОС.ОсновныеСредства КАК ВводНачальныхОстатковОСОсновныеСредства
	               |ГДЕ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка = &Ссылка";
	
	 Запрос.УстановитьПараметр("Ссылка",СтруктураШапкиДокумента.Ссылка);
	 Возврат(Запрос.Выполнить().Выгрузить());
	 
КонецФункции // 

// Получить таблицу .
//
Функция ПолучитьТаблицуМестонахождениеОС(СтруктураШапкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка КАК Регистратор,
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка.Дата КАК Период,
	               |	ВводНачальныхОстатковОСКомплектующие.ОсновноеСредство,
	               |	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация,
	               |	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК ПодразделениеОрганизации,
	               |	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК МОЛ,
	               |	ЗНАЧЕНИЕ(Справочник.Помещение.ПустаяСсылка) КАК Помещение,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ОсновноеСредство КАК ОСВладелец,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ИмяДомена
	               |ИЗ
	               |	Документ.ВводНачальныхОстатковОС.Комплектующие КАК ВводНачальныхОстатковОСКомплектующие
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковОС.ОсновныеСредства КАК ВводНачальныхОстатковОСОсновныеСредства
	               |		ПО ВводНачальныхОстатковОСКомплектующие.КлючСвязи = ВводНачальныхОстатковОСОсновныеСредства.КлючСвязи
	               |			И ВводНачальныхОстатковОСКомплектующие.Ссылка = ВводНачальныхОстатковОСОсновныеСредства.Ссылка
	               |ГДЕ
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка = &Ссылка
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка,
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка.Дата,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ОсновноеСредство,
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка.Организация,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ПодразделениеОрганизации,
	               |	ВводНачальныхОстатковОСОсновныеСредства.МОЛ,
	               |	ВводНачальныхОстатковОСОсновныеСредства.Помещение,
	               |	ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка),
	               |	ВводНачальныхОстатковОСОсновныеСредства.ИмяДомена
	               |ИЗ
	               |	Документ.ВводНачальныхОстатковОС.ОсновныеСредства КАК ВводНачальныхОстатковОСОсновныеСредства
	               |ГДЕ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка = &Ссылка";
	
	 Запрос.УстановитьПараметр("Ссылка",СтруктураШапкиДокумента.Ссылка);
	 Возврат(Запрос.Выполнить().Выгрузить());
	 
КонецФункции // 

// Получить таблицу .
//
Функция ПолучитьТаблицуКомплектующиеОС(СтруктураШапкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка КАК Регистратор,
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка.Дата КАК Период,
	               |	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство,
	               |	ВводНачальныхОстатковОСКомплектующие.ОсновноеСредство КАК Комплектующая
	               |ИЗ
	               |	Документ.ВводНачальныхОстатковОС.Комплектующие КАК ВводНачальныхОстатковОСКомплектующие
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводНачальныхОстатковОС.ОсновныеСредства КАК ВводНачальныхОстатковОСОсновныеСредства
	               |		ПО ВводНачальныхОстатковОСКомплектующие.КлючСвязи = ВводНачальныхОстатковОСОсновныеСредства.КлючСвязи
	               |			И ВводНачальныхОстатковОСКомплектующие.Ссылка = ВводНачальныхОстатковОСОсновныеСредства.Ссылка
	               |ГДЕ
	               |	ВводНачальныхОстатковОСКомплектующие.Ссылка = &Ссылка";
	
	 Запрос.УстановитьПараметр("Ссылка",СтруктураШапкиДокумента.Ссылка);
	 Возврат(Запрос.Выполнить().Выгрузить());
	 
КонецФункции // 

// Получить таблицу .
//
Функция ПолучитьТаблицуПоддержкиЛицензий(СтруктураШапкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка КАК Регистратор,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ОсновноеСредство,
	               |	ВводНачальныхОстатковОСОсновныеСредства.ДатаНачалаПоддержки КАК ДатаНачала,
	               |	ВводНачальныхОстатковОСОсновныеСредства.СрокДействия_Месяц
	               |ИЗ
	               |	Документ.ВводНачальныхОстатковОС.ОсновныеСредства КАК ВводНачальныхОстатковОСОсновныеСредства
	               |ГДЕ
	               |	ВводНачальныхОстатковОСОсновныеСредства.Ссылка = &Ссылка
	               |	И ВводНачальныхОстатковОСОсновныеСредства.ДатаНачалаПоддержки <> ДАТАВРЕМЯ(1, 1, 1)";
	
	 Запрос.УстановитьПараметр("Ссылка",СтруктураШапкиДокумента.Ссылка);
	 Возврат(Запрос.Выполнить().Выгрузить());
	 
КонецФункции // 
