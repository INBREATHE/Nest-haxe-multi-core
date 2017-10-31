package nest.injector;

#if macro
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;
using Lambda;

class InjectorMacro
{
	/**
		Do not call this method, it is called by Injector as a build macro.
	**/
	public static function findInjectMetadata():Array<Field>
	{
		Context.onGenerate(processTypes);
		return Context.getBuildFields();
	}

	static function processTypes(types:Array<Type>):Void
	{
		for (type in types) switch (type)
		{
			case TInst(t, _): processInst(t);
			default:
		}
	}

	static function processInst(t:Ref<ClassType>):Void
	{
		var ref = t.get();
        var infos = [];

		// process fields
		var fields = ref.fields.get();
		for (field in fields) processField(field, infos);

		// add rtti to type
		var rtti = infos.map(function (rtti) return macro $v{rtti});
		if (rtti.length > 0) ref.meta.add('inject', rtti, ref.pos);
	}

	static function processField(field:ClassField, rttis:Array<String>):Void
	{
		if (!field.isPublic) return;

		// find metadata
		var meta = field.meta.get();
		var inject = meta.find(function (meta) return meta.name == 'inject');

		// only process public fields with minject metadata
		if (inject == null) return;

		// extract injection names from metadata
		var names = [];
		if (inject != null)
		{
			names = inject.params;
			field.meta.remove('inject');
		}

		var rtti = field.name + ":" + field.type.toString();
		rttis.push(rtti);
	}
}
#end
