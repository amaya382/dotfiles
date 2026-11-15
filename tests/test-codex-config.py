from pathlib import Path
import importlib.util,tempfile,tomllib,datetime
spec=importlib.util.spec_from_file_location('renderer',Path(__file__).resolve().parent.parent / 'bootstrap/render-codex-config.py'); mod=importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
def apply(base, local):
    mod.run(base,local,'capture')
    result=mod.run(base,local)
    (local/'config.toml').write_text(result)
    mod.run(base,local,'record')
    return tomllib.loads(result)
with tempfile.TemporaryDirectory() as temp:
    root=Path(temp); base=root/'base.toml'; local=root/'codex'; local.mkdir()
    base.write_text('model="shared"\nmodel_reasoning_effort="medium"\n[realtime]\nvoice="maple"\n')
    original=tomllib.loads(base.read_text()); original['projects']={'/private/path':{'trust_level':'trusted'}}; original['tui']={'screen_reader_detection_done':True}
    (local/'config.toml').write_text(mod.dump(original))
    before={p:p.read_bytes() for p in local.iterdir()}; mod.run(base,local)
    assert before=={p:p.read_bytes() for p in local.iterdir()}
    assert apply(base,local)==original
    overlay=mod.load(local/'config.local.toml'); assert set(overlay)=={'projects','tui'}
    base.write_text(base.read_text().replace('shared','new-shared'))
    mod.run(base,local); mod.run(base,local)
    modified=mod.load(local/'config.toml'); modified['model_reasoning_effort']='high'
    (local/'config.toml').write_text(mod.dump(modified))
    updated=apply(base,local); assert updated['model']=='new-shared'; assert updated['model_reasoning_effort']=='high'
    assert 'model' not in mod.load(local/'config.local.toml')
    updated['mcp_servers']={'local':{'args':['a','b']}}; (local/'config.toml').write_text(mod.dump(updated)); assert apply(base,local)==updated
    updated.pop('mcp_servers'); (local/'config.toml').write_text(mod.dump(updated)); assert 'mcp_servers' not in apply(base,local)
    before={p:p.read_bytes() for p in (local/'config.local.toml',local/'.config.rendered.toml')}
    (local/'config.toml').write_text('invalid = [')
    try: mod.run(base,local,'capture')
    except tomllib.TOMLDecodeError: pass
    else: raise AssertionError('invalid live config accepted')
    assert all(p.read_bytes()==data for p,data in before.items())
    fresh=root/'fresh'; fresh.mkdir()
    (fresh/'config.toml').write_text('model="local"\n')
    (fresh/'config.local.toml').write_text('[realtime]\nvoice="cedar"\n')
    assert apply(base,fresh)['realtime']['voice']=='cedar'
    assert (fresh/'config.local.toml').stat().st_mode & 0o777 == 0o600
    other=root/'linked'; other.mkdir(); (other/'config.toml').symlink_to(base)
    try: mod.run(base,other)
    except ValueError: pass
    else: raise AssertionError('Symlink accepted')
    fixture={'array':[1,True,{'nested':'value'}],'quoted.key':{'slash/path':'日本語\ntext'},'date':datetime.date(2026,11,15),'float':1.25,'empty':{}}
    assert tomllib.loads(mod.dump(fixture))==fixture
print('Passed: migration, local isolation, read-only preview, shared updates after preview plus edits, local overrides, removals, invalid TOML, symlink rejection, serialization, mode 0600.')
