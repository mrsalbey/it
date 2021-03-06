////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ЗАПОЛНЕНИЯ ДОКУМЕНТА


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
	//ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ОсновноеСредство", "НаименованиеПолное",   "НаименованиеПолное");
	
	СтруктураШапкиДокумента = ОбщегоНазначенияСервер.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияСервер.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента() 

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента() Экспорт
	
	//СтруктураШапкиДокумента.ТаблицыДляДвижений.Вставить("ТаблицаПоддержкаЛицензий", Документы.ПокупкаПоддержкиЛицензий.ПолучитьТаблицуПоддержкиЛицензий(СтруктураШапкиДокумента));
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПоддержкаЛицензий", Документы.ПокупкаПоддержкиЛицензий.ПолучитьТаблицуПоддержкиЛицензий(ДополнительныеСвойства));
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗакупки", Документы.ПокупкаПоддержкиЛицензий.ПолучитьТаблицуЗакупки(ДополнительныеСвойства));
	
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
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ОтражениеПоРегистрамСервер.ОтразитьПоддержкиЛицензий(ДополнительныеСвойства, Движения, Отказ);
	ОтражениеПоРегистрамСервер.ОтразитьЗакупкуЛицензий(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
    
		Возврат;
		
	КонецЕсли;
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
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
	
	//ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);
	ПодготовитьТаблицыДокумента();
	
	ЗаполнениеДокументовСервер.ПроверитьДублиТабличнойЧасти(СтруктураШапкиДокумента, Отказ, Заголовок, "ОсновноеСредство", "ОсновныеСредства");
	
	//УправлениеОсновнымиСредствамиСервер.СуществованиеДвиженийМестонахождениеОС("ОсновныеСредства", СтруктураШапкиДокумента, Отказ, Заголовок, ЭтотОбъект, Ложь);	
	
	Если Не Отказ Тогда
		
		//ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);
		
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
