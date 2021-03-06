////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ЗАПОЛНЕНИЯ ДОКУМЕНТА

// Процедура заполняет номера и даты платежно-расчетных документов.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//
Процедура ЗаполнитьОсновноеСредство(ДанныеЗаполнения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаказКлиента = Неопределено;
	Если ТипЗнч(ДанныеЗаполнения.ОсновноеСредство) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		
		НоваяСтрока = ОсновныеСредства.Добавить();
		НоваяСтрока.ОсновноеСредство 	= ДанныеЗаполнения.ОсновноеСредство;
		
		др_КоличествоПользователей = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Количество пользователей");
		НайденнаяСтрока = ДанныеЗаполнения.ОсновноеСредство.ДополнительныеРеквизиты.Найти(др_КоличествоПользователей, "Свойство");
		Если НайденнаяСтрока <> Неопределено Тогда
			НоваяСтрока.Количество	= НайденнаяСтрока.Значение;
		КонецЕсли;	
		
	КонецЕсли;
	
	
КонецПроцедуры // ЗаполнитьОсновноеСредство()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, РежимПроведения = Неопределено) Экспорт
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначенияСервер.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияСервер.СформироватьДеревоПолейЗапросаПоШапке();
	
	СтруктураШапкиДокумента = ОбщегоНазначенияСервер.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияСервер.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента() 

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента() Экспорт
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаМестонахождениеОС", Документы.ПоступлениеОС.ПолучитьТаблицуМестонахождениеОС(ДополнительныеСвойства));
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗакупки", Документы.ПоступлениеОС.ПолучитьТаблицуЗакупки(ДополнительныеСвойства));
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЛицензииОрганизации", Документы.ПоступлениеОС.ПолучитьТаблицуЛицензииОрганизации(ДополнительныеСвойства));
	
КонецПроцедуры // ПодготовитьТаблицыДокумента()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары,
//  ТаблицаПоСкидкам          - таблица значений, содержащая данные для проведения и проверки ТЧ Скидки,
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  ТаблицаПоУслугам          - таблица значений, содержащая данные для проведения и проверки ТЧ "Услуги",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, ДополнительныеСвойства, Отказ, Заголовок)
	
	ОтражениеПоРегистрамСервер.ОтразитьМестонахождениеОС(ДополнительныеСвойства, Движения, Отказ);
	ОтражениеПоРегистрамСервер.ОтразитьЗакупкуЛицензий(ДополнительныеСвойства, Движения, Отказ);
	ОтражениеПоРегистрамСервер.ОтразитьЛицензииОрганизации(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
    
		Возврат;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьОсновноеСредство(ДанныеЗаполнения);
		
	КонецЕсли;

КонецПроцедуры


// Функция формирует временные данных документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПоступлениеОСОсновныеСредства.ОсновноеСредство,
	               |	ПоступлениеОСОсновныеСредства.Количество,
	               |	ПоступлениеОСОсновныеСредства.Стоимость
	               |ПОМЕСТИТЬ втТаблицаОсновныеСредства
	               |ИЗ
	               |	Документ.ПоступлениеОС.ОсновныеСредства КАК ПоступлениеОСОсновныеСредства
	               |ГДЕ
	               |	ПоступлениеОСОсновныеСредства.Ссылка = &Ссылка";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции // ВременныеТаблицыДанныхДокумента()


// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ЗаполнитьВременныеТаблицы(Отказ)

	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();

КонецПроцедуры // ЗаполнитьВременныеТаблицы()


// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("ОсновноеСредство");
	ЗаполнениеДокументовСервер.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "СведенияОС", КлючевыеРеквизиты, Отказ,, Истина);
	
	ОтражениеПоРегистрамСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ЗаполнитьВременныеТаблицы(Отказ);
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры


Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Контроль выполняется при проведении\отмене проведения не нового документа.

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры // СформироватьСписокРегистровДляКонтроля()


// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	Перем ТаблицаПроверки;
	
	// Подготовим структуру шапки документа
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, РежимПроведения);
	
	//ОтражениеПоРегистрамСервер.ДополнительныеСвойстваДляПроведения(Ссылка, СтруктураШапкиДокумента);
	ОтражениеПоРегистрамСервер.ДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПодготовитьТаблицыДокумента();
	
	//ЗаполнениеДокументовСервер.ПроверитьДублиТабличнойЧасти(СтруктураШапкиДокумента, Отказ, Заголовок, "ОсновноеСредство","ОсновныеСредства");
	ЗаполнениеДокументовСервер.ПроверитьДублиТабличнойЧасти(СтруктураШапкиДокумента, Отказ, Заголовок, "ОсновноеСредство", "СведенияОС");
	
	//Комиссаров: 06/08/2013 закомментировал до выяснения необходимости проверок
	//УправлениеОсновнымиСредствамиСервер.СуществованиеДвиженийМестонахождениеОС("ОсновныеСредства", СтруктураШапкиДокумента, Отказ, Заголовок, ЭтотОбъект, Истина);	
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(РежимПроведения, ДополнительныеСвойства, Отказ, Заголовок);
		
		СформироватьСписокРегистровДляКонтроля();
		
		ОтражениеПоРегистрамСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
		ОтражениеПоРегистрамСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
		
		ОтражениеПоРегистрамСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	
КонецПроцедуры
