Scene = {
-- シーンに登録されているアクターから指定されたクラスのアクターのテーブルを取得します
GetActorsByClassName = function( scene, className ) 
	actors = scene:GetActorList();
	return DataActor.GetActorsByClassName(actors, className)
end
}
